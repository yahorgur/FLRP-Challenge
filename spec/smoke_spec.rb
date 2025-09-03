# frozen_string_literal: true

require 'open3'

RSpec.describe 'bin/run.rb' do
  it 'prints the expected greeting' do
    stdout_str, stderr_str, status = Open3.capture3(File.expand_path('../bin/run.rb', __dir__))

    expect(status.exitstatus).to eq(0), "Expected exit status 0, got #{status.exitstatus}, stderr: #{stderr_str}"
    expect(stdout_str).to eq("Hello, Fund Load Processor!\n")
  end
end
