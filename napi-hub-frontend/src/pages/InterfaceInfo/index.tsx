import {
  getInterfaceInfoByIdUsingGET,
  invokeInterfaceInfoUsingPOST,
} from '@/services/napi-hub/interfaceInfoController';
import { useParams } from '@@/exports';
import { PageContainer } from '@ant-design/pro-components';
import { Button, Card, Descriptions, Divider, Form, Input, message } from 'antd';
import React, { useEffect, useState } from 'react';

/**
 * 主页
 * @constructor
 */
const Index: React.FC = () => {
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<API.InterfaceInfo>();
  const [invokeRes, setInvokeRes] = useState<any>();
  const [invokeLoading, setInvokeLoading] = useState(false);

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
    setLoading(false);
  };

  useEffect(() => {
    loadData();
  }, []);

  const onFinish = async (values: any) => {
    if (!params.id) {
      message.error('Sorry, This API is No Longer Available');
      return;
    }
    setInvokeLoading(true);
    try {
      const res = await invokeInterfaceInfoUsingPOST({
        id: params.id,
        ...values,
      });
      setInvokeRes(res.data);
      message.success('Success');
    } catch (error: any) {
      message.error('Oops, Something Went Wrong. ' + error.message);
    }
    setInvokeLoading(false);
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
            <Descriptions.Item label="Creation Time">{data.createTime}</Descriptions.Item>
            <Descriptions.Item label="Update Time">{data.updateTime}</Descriptions.Item>
          </Descriptions>
        ) : (
          <>API does not exist</>
        )}
      </Card>
      <Divider />
      <Card title="API playground">
        <Form name="invoke" layout="vertical" onFinish={onFinish}>
          <Form.Item label="Parameter Fields" name="userRequestParams">
            <Input.TextArea />
          </Form.Item>
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
