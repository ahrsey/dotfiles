return {
	"vimwiki/vimwiki",
	config =  function()
		vim.g["vimwiki_list"] = {
			{ path = "~/vimwiki/", path_html = "~/vimwiki_html/" },
			{ path = "~/wikis/aws/" },
			{ path = "~/wikis/blog/", syntax = "markdown", ext = ".md" },
		}
		vim.g["vimwiki_global_ext"] = 0
	end
}
