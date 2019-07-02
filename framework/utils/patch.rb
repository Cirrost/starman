module Utils
  def patch_data data
    file = File.open('patch.diff', 'w')
    file << data
    file.close
    system 'patch --ignore-whitespace -N -p1 < patch.diff'
    CLI.error 'Failed to apply patch!' unless $?.success?
  end

  def patch_file path, options={}
    system "patch --ignore-whitespace -N -p#{options[:strip] || 0} < #{path}"
    CLI.error 'Failed to apply patch!' unless $?.success?
  end
end
