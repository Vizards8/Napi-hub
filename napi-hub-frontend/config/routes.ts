export default [
  { path: '/', name: 'Homepage', icon: 'smile', component: './Index' },
  { path: '/interface_info/:id', name: '查看接口', icon: 'smile', component: './InterfaceInfo', hideInMenu: true },
  {
    path: '/user',
    layout: false,
    routes: [
      { name: 'Login', path: '/user/login', component: './User/Login' },
      { name: 'Register', path: '/user/register', component: './User/Register' },
    ],
  },
  {
    path: '/admin',
    name: 'Admin page',
    icon: 'crown',
    access: 'canAdmin',
    routes: [
      { name: 'API Management ', icon: 'table', path: '/admin/interface_info', component: './Admin/InterfaceInfo' },
      { name: 'API Analysis', icon: 'analysis', path: '/admin/interface_analysis', component: './Admin/InterfaceAnalysis' },
    ],
  },

  // { path: '/', redirect: '/welcome' },
  { path: '*', layout: false, component: './404' },
];
