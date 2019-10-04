import React, {Component} from 'react'

class TestComponent extends Component {
  constructor(props) {
    super(props)

    this.state = props
  }

  onClick = () => {
    this.setState(() => ({
      name: "Revelry"
    }))
  }

  render() {
    const {name} = this.state

    return (
      <div onClick={this.onClick}>
        👋 {name}
      </div>
    )
  }
}

export default TestComponent
