import React from 'react'
import ReactDOM from 'react-dom'

/**
 * Hydrates react components that had HTML created from server.
 * Looks for divs with 'data-rendered' attributes. Gets component
 * name from the 'data-component' attribute and props from the
 * 'data-props' attribute.
 * @param {Function} componentMapper - A function that takes in a name and returns the component
 */
export function hydrateClient(componentMapper) {
  var serverRenderedComponents = document.querySelectorAll('[data-rendered]')
  var serverRenderedComponentsLength = serverRenderedComponents.length;

  for (var i = 0; i < serverRenderedComponentsLength; i++) {
    var serverRenderedComponent = serverRenderedComponents[i];

    var component = componentMapper(serverRenderedComponent.dataset.component)
    var props = JSON.parse(serverRenderedComponent.dataset.props)
    var element = React.createElement(component, props)

    ReactDOM.hydrate(element, serverRenderedComponent)
  }
}
