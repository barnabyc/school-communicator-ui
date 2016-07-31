import React from 'react';
import ReactDOM from 'react-dom';
import AuthService from './lib/auth_service'

import Welcome from './components/welcome';

// todo: move this to environment
const AUTH0_CLIENT_ID = '';
const AUTH0_DOMAIN = '';

const auth = new AuthService(AUTH0_CLIENT_ID, AUTH0_DOMAIN);

ReactDOM.render(
  <Welcome auth={auth} />,
  document.getElementById('app')
);

