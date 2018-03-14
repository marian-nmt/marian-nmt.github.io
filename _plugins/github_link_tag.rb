module Jekyll
  class GithubLinkTag < Liquid::Tag
    def initialize(tag_name, path, tokens)
      super
      path.gsub!(/^\/+|\/+$/, '')
      path.gsub!(/\n+/, ' ')
      if path =~ /.*"(.+)".*/
          @text = $1
          path.sub!(/\s*".*"\s*/, '')
      end
      @repo, @path = path.split('/', 2)
      @repo.strip! unless @repo.nil?
      @path.strip! unless @path.nil?
    end

    def render(context)
      url_base = context.registers[:site].config['github']
      url = "#{url_base}/#{@repo}/tree/master/#{@path}"
      text = @text || "<code class=\"highlighter-rogue\">#{@repo}/#{@path}</code>"
      "<a class=\"github-link\" href=\"#{url}\" target=\"_blank\">" \
        "#{text}" \
      "</a>"
    end
  end
end

Liquid::Template.register_tag('github_link', Jekyll::GithubLinkTag)
