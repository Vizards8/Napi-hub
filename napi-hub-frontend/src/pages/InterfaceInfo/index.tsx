import {
  getInterfaceInfoByIdUsingGET,
  getRemainingCallsUsingGET,
  invokeInterfaceInfoUsingPOST,
  subscribeInterfaceUsingPOST,
} from '@/services/napi-hub/interfaceInfoController';
import { useParams } from '@@/exports';
import { CloudFilled } from '@ant-design/icons';
import { PageContainer } from '@ant-design/pro-components';
import { Button, Card, Descriptions, Divider, Form, Input, message, Space, Typography } from 'antd';
import { isNull } from 'lodash';
import React, { useEffect, useState } from 'react';

const { Title, Paragraph, Text, Link } = Typography;

/**
 * 主页
 * @constructor
 */
const Index: React.FC = () => {
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<API.InterfaceInfo>();
  const [invokeRes, setInvokeRes] = useState<any>();
  const [invokeLoading, setInvokeLoading] = useState(false);
  const [remainingCalls, setRemainingCalls] = useState(0);
  const [firstTimeUser, setFirstTimeUser] = useState(false);

  const params = useParams();

  const loadData = async () => {
    if (!params.id) {
      message.error('Required Parameters Missing');
      return;
    }

    setLoading(true);

    try {
      const res = await getInterfaceInfoByIdUsingGET({
        id: Number(params.id),
      });
      setData(res.data);
    } catch (error: any) {
      message.error('Oops, Something Went Wrong. ' + error.message);
    }

    try {
      const res = await getRemainingCallsUsingGET({
        id: Number(params.id),
      });
      if (res.data === null) {
        setFirstTimeUser(true);
      } else {
        setRemainingCalls(res.data);
      }
    } catch (error: any) {
      message.error('Oops, Something Went Wrong. ' + error.message);
    }

    setLoading(false);
  };

  useEffect(() => {
    loadData();
  }, [firstTimeUser, remainingCalls]);

  const onFinish = async (values: any) => {
    if (!params.id) {
      message.error('Sorry, This API is No Longer Available');
      return;
    }
    if (firstTimeUser) {
      message.warning('Please subscribe first to get your free trials!');
      return;
    }
    setInvokeLoading(true);
    try {
      const res = await invokeInterfaceInfoUsingPOST({
        id: Number(params.id),
        userRequestParams: JSON.stringify(values),
      });
      setInvokeRes(res.data);
      setRemainingCalls(remainingCalls - 1);
      message.success('Success');
    } catch (error: any) {
      message.error('Oops, Something Went Wrong. ' + error.message);
    }
    setInvokeLoading(false);
  };

  const handleSubscribe = async () => {
    try {
      await subscribeInterfaceUsingPOST({
        id: Number(params.id),
      });
      message.success('Subscribe Success');
      setFirstTimeUser(false);
    } catch (error: any) {
      message.error('Oops, Something Went Wrong. ' + error.message);
    }
  };

  return (
    <PageContainer title="API Documentation">
      <Card>
        {data ? (
          <Descriptions title={data.name} column={1}>
            <Descriptions.Item label="Interface Status">
              {data.status ? 'Open' : 'Closed'}
            </Descriptions.Item>
            <Descriptions.Item label="Description">{data.description}</Descriptions.Item>
            <Descriptions.Item label="Request URL">{data.url}</Descriptions.Item>
            <Descriptions.Item label="Request Method">{data.method}</Descriptions.Item>
            <Descriptions.Item label="Request Parameters">{data.requestParams}</Descriptions.Item>
            <Descriptions.Item label="Request Headers">{data.requestHeader}</Descriptions.Item>
            <Descriptions.Item label="Response Headers">{data.responseHeader}</Descriptions.Item>
          </Descriptions>
        ) : (
          <>API does not exist</>
        )}
      </Card>
      <Divider />
      <Card title="Remaining API Calls">
        <Space direction="vertical">
          {firstTimeUser ? (
            <Space>
              First time user? Subscribe now to unlock your free trials!
              <Button type="primary" onClick={handleSubscribe}>
                Subscribe Now
              </Button>
            </Space>
          ) : (
            <Text>You have {remainingCalls} calls remaining.</Text>
          )}
        </Space>
      </Card>
      <Divider />
      <Card title="API playground">
        <Form name="invoke" layout="vertical" onFinish={onFinish}>
          <Title level={4}>Parameter Fields</Title>
          {data && JSON.parse(data.requestParams).length > 0 ? (
            JSON.parse(data.requestParams).map((param, index) => (
              <Form.Item
                key={index}
                label={param.name}
                name={param.name}
                rules={[
                  {
                    required: true,
                    message: 'This field is required!',
                  },
                ]}
              >
                <Input.TextArea />
              </Form.Item>
            ))
          ) : (
            <Form.Item label="None">
              <Input.TextArea placeholder="No parameters are needed for this API." />
            </Form.Item>
          )}
          <Form.Item wrapperCol={{ span: 16 }}>
            <Button type="primary" htmlType="submit">
              Send Request
            </Button>
          </Form.Item>
        </Form>
      </Card>
      <Divider />
      <Card title="Result" loading={invokeLoading}>
        {invokeRes}
      </Card>
    </PageContainer>
  );
};

export default Index;
