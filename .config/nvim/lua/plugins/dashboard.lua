return {
	{
		"nvimdev/dashboard-nvim",
		opts = function(_, opts)
			local logo = [[
        •                   ┓  ┓     ┏  ┓┓   ╹   ┓      ┓┏•   
┏┓┏┓┏┓┓┏┓┏┳┓  ┏┓┏┓┓┏┏┏┓┏┓┏┓┏┫  ┣┓┓┏  ╋┏┓┃┃┏┏┓ ┏  ┃ ┏┓┓┓┏┃┃┓┏┳┓
┛┗┗ ┗┛┗┛┗┛┗┗  ┣┛┗┛┗┻┛┗ ┛ ┗ ┗┻  ┗┛┗┫  ┛┗┛┗┛┗┗  ┛  ┗┛┗┻┗┗┫┗┛┗┛┗┗
              ┛                   ┛                    ┛      
 neovim 
      ]]
			opts.config.header = vim.split(logo, "\n")
		end,
	},
}
