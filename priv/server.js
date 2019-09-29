const ReactServer = require('react-dom/server')
const React = require('react')
const readline = require('readline')

function deleteCache(componentPath) {
  if (
    process.env.NODE_ENV !== 'production' &&
    require.resolve(componentPath) in require.cache
  ) {
    delete require.cache[require.resolve(componentPath)]
  }
}

function requireComponent(componentPath) {
  // remove from cache in non-production environments
  // so that we can see changes
  deleteCache(componentPath)

  return require(componentPath)
}

function render(componentPath, props) {
  try {
    const component = requireComponent(componentPath)
    const element = component.default ? component.default : component
    const createdElement = React.createElement(element, props)

    const markup = ReactServer.renderToString(createdElement)

    const response = {
      error: null,
      markup: markup,
      component: element.name,
    }

    return response
  } catch (err) {
    const response = {
      path: componentPath,
      error: {
        type: err.constructor.name,
        message: err.message,
        stack: err.stack,
      },
      markup: null,
      component: null,
    }

    return response
  }
}

module.exports = {
  render,
}
