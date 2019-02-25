require 'singleton'

class PodfilePatch
  include Singleton
  attr_reader :source_pods
  attr_reader :disable_pods
  attr_reader :original_pods

  def initialize
    patch_paths = [
      ENV['PODFILE_PATCH'], './.Podfile.patch', '~/.Podfile.patch'
    ].compact
    patch_content = nil
    patch_paths.each do |p|
      abs_p = File.expand_path(p)
      next unless File.exist? abs_p
      puts "Using #{abs_p} as patch for Podfile"
      patch_content = File.read(abs_p)
      break
    end

    @source_pods = []
    @disable_pods = []
    @original_pods = {}
    return unless patch_content
    patch_content.lines.each do |line|
      line.strip!
      next if line.length < 3
      next if line[0] == '#' # 注释
      func = line.split.first
      pod_name = line.split[1].delete('"').delete("'").delete(',')
      pod_name_base = pod_name.split('/').first
      case func
      when 'source_pod'
        # 源码
        @source_pods << pod_name_base
      when 'disable_pod'
        # 禁用
        @disable_pods << pod_name
      when 'pod'
        # 原生
        @original_pods[pod_name_base] = line
      else
        raise "Unknown syntax: #{line}"
      end
    end
    self.report
  end

  def report
    if @disable_pods.length > 0
      puts "[.Podfile.patch] Pod(s) disabled:"
      puts @disable_pods.join(', ')
      puts ""
    end
    if @source_pods.length > 0
      puts "[.Podfile.patch] Pod(s) coming with source code:"
      puts @source_pods.join(', ')
      puts ""
    end
    if @original_pods.length > 0
      puts "[.Podfile.patch] Pod(s) coming with original pod declaration:"
      puts @original_pods.keys.join(', ')
      puts ""
    end
  end
end

def vite_pod(pod_name, info)
  pod_name_base = pod_name.split('/').first

  # 被 patch 禁用的 pod，直接返回
  return if PodfilePatch.instance.disable_pods.include?(pod_name)

  original_pod_line = PodfilePatch.instance.original_pods[pod_name_base]
  if original_pod_line
    # 使用原生 pod 命令引入的，直接用 eval 引入，默认 original_pod_line 合法
    eval original_pod_line
  else
    pod pod_name, info
  end
end




