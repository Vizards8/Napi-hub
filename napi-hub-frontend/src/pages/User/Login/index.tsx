import Footer from '@/components/Footer';
import { userLoginUsingPOST } from '@/services/napi-hub/userController';
import { LockOutlined, UserOutlined } from '@ant-design/icons';
import { LoginForm, ProFormCheckbox, ProFormText } from '@ant-design/pro-components';
import { history, useModel } from '@umijs/max';
import { Button, message, Tabs } from 'antd';
import React, { useState } from 'react';
import styles from './index.less';

const Login: React.FC = () => {
  const [type, setType] = useState<string>('account');
  const { initialState, setInitialState } = useModel('@@initialState');
  const handleSubmit = async (values: API.UserLoginRequest) => {
    try {
      // 登录
      const res = await userLoginUsingPOST({
        ...values,
      });
      if (res.data) {
        const urlParams = new URL(window.location.href).searchParams;
        history.push(urlParams.get('redirect') || '/');
        setInitialState({
          loginUser: res.data,
        });
        return;
      }
    } catch (error) {
      const defaultLoginFailureMessage = 'Login failed, please try again!';
      console.log(error);
      message.error(defaultLoginFailureMessage);
    }
  };

  return (
    <div className={styles.container}>
      <div className={styles.content}>
        <LoginForm
          logo={<img alt="logo" src="/logo.svg" />}
          title="NApi"
          subTitle={'API Open Platform'}
          initialValues={{
            autoLogin: true,
          }}
          onFinish={async (values) => {
            await handleSubmit(values as API.UserLoginRequest);
          }}
          submitter={{
            render: () => {
              return (
                <Button style={{ width: '100%' }} size="large" type="primary" htmlType="submit">
                  Log in
                </Button>
              );
            },
          }}
        >
          <Tabs
            activeKey={type}
            onChange={setType}
            centered
            style={{ width: '100%', maxWidth: '400px' }}
            items={[
              {
                key: 'account',
                label: 'User Login',
              },
            ]}
          />

          <>
            <ProFormText
              name="userAccount"
              fieldProps={{
                size: 'large',
                prefix: <UserOutlined className={styles.prefixIcon} />,
              }}
              placeholder={'laphi'}
              rules={[
                {
                  required: true,
                  message: 'Username is required!',
                },
              ]}
            />
            <ProFormText.Password
              name="userPassword"
              fieldProps={{
                size: 'large',
                prefix: <LockOutlined className={styles.prefixIcon} />,
              }}
              placeholder={'12345678'}
              rules={[
                {
                  required: true,
                  message: 'Password is required!',
                },
              ]}
            />
          </>

          <div
            style={{
              marginBottom: 18,
            }}
          >
            <ProFormCheckbox noStyle name="autoLogin">
              Remember me
            </ProFormCheckbox>
          </div>
          <div
            style={{
              marginBottom: 18,
            }}
          >
            Don't have an account? <a href="/user/register">Register Now!</a>
          </div>
        </LoginForm>
      </div>
      <Footer />
    </div>
  );
};
export default Login;
