
class Ppl::Adapter::Storage::Factory

  def load_adapter(directory)
    git_dir = File.join(directory.path, ".git")

    disk_adapter = Ppl::Adapter::Storage::Disk.new(directory)
    adapter      = disk_adapter

    if File.exists?(git_dir)
      git_adapter = Ppl::Adapter::Storage::Git.new(disk_adapter)
      adapter     = git_adapter
    end

    return adapter
  end

end

