import React, { PropTypes as T } from 'react';
import AuthService from '../lib/auth_service'

const Welcome = ({ auth }) => (
  <div className="page">
    <h2>Welcome to Athenaeum Learning Center's Portal</h2>
    <div className="description">
      Please login below to get started.
    </div>
    <div>
      <button onClick={auth.login.bind(this)}>Login</button>
    </div>
  </div>
);

Welcome.propTypes = {
  auth: T.instanceOf(AuthService)
}

export default Welcome;
