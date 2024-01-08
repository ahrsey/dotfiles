vim.g["vimwiki_list"] = {
  { path = "~/vimwiki/" },
  { path = "~/wikis/aws/" },
  { path = "~/Repos/blog/posts/", syntax = "markdown", ext = ".md" },
}

return {
	"vimwiki/vimwiki",
	config =  function()
		-- vim.g["vimwiki_global_ext"] = 0
	end
}
