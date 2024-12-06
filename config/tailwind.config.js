const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{rb,erb,haml,html,slim}'
  ],
  safelist: [
    'pagy',
    'spinner',
    'choices__list',
    'choices__list--dropdown',
    'choices__placeholder',
    'choices__input--cloned',
    'choices__list--single',
    'choices__item--choice',
    'is-active',
    'is-selected',
    'is-highlighted',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      fontSize: {
        'xxs': ['10px', '12px'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    ({addVariant}) => {
      addVariant("turbo-native", "html[data-turbo-native] &"),
          addVariant('non-turbo-native', "html:not([data-turbo-native]) &")
    }
  ]
}
