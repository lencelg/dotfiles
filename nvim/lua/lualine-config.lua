require('lualine').setup{
    options = {
        theme = 'palenight',
        section_separators = '',
        component_separators = '',
    },
    sections = {
        lualine_a = {'mode'},
        lualine_x = {function () return 'lencelg' end},
     },
}
