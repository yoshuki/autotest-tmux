require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Autotest::Tmux do
  context 'All added hooks should be called by autotest' do
    Autotest::HOOKS.keys.each do |hook|
      subject { Autotest::ALL_HOOKS }
      it { should include(hook) }
    end
  end

  describe 'When display message' do
    context 'without params' do
      it { Autotest::Tmux.message.should be_true }
    end

    context 'with String as message' do
      it { Autotest::Tmux.message('foo').should be_true }
    end

    context 'with nil as message' do
      it { Autotest::Tmux.message(nil).should be_true }
    end

    context 'with Symbol as color' do
      it { Autotest::Tmux.message('foo', :black).should be_true }
    end

    context 'with nil as color' do
      it { Autotest::Tmux.message('foo', nil).should be_true }
    end
  end

  after(:all) do
    Autotest::Tmux.clear
  end
end
