import Footer from '@/components/Footer';
import { userRegisterUsingPOST } from '@/services/napi-hub/userController';
import { LockOutlined, UserOutlined } from '@ant-design/icons';
import { LoginForm, ProFormText } from '@ant-design/pro-components';
import { history } from '@umijs/max';
import { Alert, message, Tabs, Button } from 'antd';
import React, { useState } from 'react';
import styles from './index.less';

const Register: React.FC = () => {
  const [type, setType] = useState<string>('account');
  const handleSubmit = async (values: API.UserRegisterRequest) => {
    try {
      // 注册
      const res = await userRegisterUsingPOST({
        ...values,
      });
      if (res.data) {
        message.success('Register success, please log in!');
        const urlParams = new URL(window.location.href).searchParams;
        history.push(urlParams.get('redirect') || '/user/login');
        return;
      }
    } catch (error) {
      const defaultRegisterFailureMessage = 'Register failed, please try again!';
      console.log(error);
      message.error(defaultRegisterFailureMessage);
    }
  };

  return (
    <div className={styles.container}>
      <div className={styles.content}>
        <LoginForm
          logo={<img alt="logo" src="/logo.svg" />}
          title="NApi"
          subTitle={'API Open Platform'}
          onFinish={async (values) => {
            await handleSubmit(values as API.UserRegisterRequest);
          }}
          submitter={{
            render: () => {
              return (
                <Button style={{ width: '100%' }} size='large' type="primary" htmlType="submit">
                  Register
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
                label: 'User Register',
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
              placeholder={'Account'}
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
              placeholder={'Password'}
              rules={[
                {
                  required: true,
                  message: 'Password is required!',
                },
              ]}
            />
            <ProFormText.Password
              name="checkPassword"
              fieldProps={{
                size: 'large',
                prefix: <LockOutlined className={styles.prefixIcon} />,
              }}
              placeholder={'Comfirm Password'}
              rules={[
                {
                  required: true,
                  message: 'Confirm password is required!',
                },
              ]}
            />
          </>

          <div
            style={{
              marginBottom: 24,
            }}
          >
            Already have an account? <a href="/user/login">Log in!</a>
          </div>
        </LoginForm>
      </div>
      <Footer />
    </div>
  );
};
export default Register;
