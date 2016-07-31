import React from 'react';

class CommunicationCenter extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (
      <div className="page">
        <h2>Communication Center</h2>
        <div className="description">
          Communication is key! On this page, parents, teachers, students, and
          administrators can easily view, send, and reply to communications.
        </div>
        <div id="communication-center-elm"></div>
      </div>
    );
  }
  componentDidMount() {
    if (Elm && Elm.Main) Elm.Main.embed(
      document.getElementById('communication-center-elm')
    );
  }
}


// todo: pass through to Elm

export default CommunicationCenter;
