import { GithubOutlined } from '@ant-design/icons';
import { DefaultFooter } from '@ant-design/pro-components';
import '@umijs/max';
const Footer: React.FC = () => {
  const defaultMessage = 'Produced by Neng';
  const currentYear = new Date().getFullYear();
  return (
    <DefaultFooter
      style={{
        background: 'none',
      }}
      copyright={`${currentYear} ${defaultMessage}`}
      links={[
        {
          key: 'NApi',
          title: 'NApi',
          href: 'https://124.222.227.94/napi',
          blankTarget: true,
        },
        {
          key: 'github',
          title: <GithubOutlined />,
          href: 'https://github.com/Vizards8',
          blankTarget: true,
        },
        {
          key: 'Neng',
          title: 'Neng',
          href: 'https://github.com/Vizards8',
          blankTarget: true,
        },
      ]}
    />
  );
};
export default Footer;
