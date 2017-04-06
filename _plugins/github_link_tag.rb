module Jekyll
  class GithubLinkTag < Liquid::Tag

    def initialize(tag_name, path, tokens)
      super
      path.gsub!(/^\/+|\/+$/, '')
      @repo, @path = path.split('/', 2)
    end

    def render(context)
      url_base = context.registers[:site].config['github']
      url = "#{url_base}/#{@repo}/tree/master/#{@path}"
      "<a class=\"github-link\" href=\"#{url}\" target=\"_blank\">" \
        "<code class=\"highlighter-rogue\">#{@repo}/#{@path}</code>" \
      "</a>"
    end
  end
end

Liquid::Template.register_tag('github_link', Jekyll::GithubLinkTag)
