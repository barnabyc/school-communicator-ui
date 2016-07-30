const ReactDOM = require('react-dom');
const React = require('react');

const Foo = () => {
  return (
    <div>[foo]</div>
  )
}

ReactDOM.render(
  <Foo />,
  document.getElementById('app')
);
