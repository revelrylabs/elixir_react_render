import React, {useState} from 'react'

function TestComponent(props) {
  const [name, setName] = useState(props.name)
  const onClick = () => setName('Revelry')

  return (
    <div onClick={onClick}>
      👋 {name}
    </div>
  )
}

export default TestComponent
