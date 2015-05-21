if defined?(ChefSpec)
  def enable_windows_autologin(username)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_autologin, :enable, username)
  end

  def disable_windows_autologin(username)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_autologin, :disable, username)
  end
end
