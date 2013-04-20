require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Autotest::Tmux do
  context 'All added hooks should be called by autotest' do
    Autotest::HOOKS.keys.each do |hook|
      subject { Autotest::ALL_HOOKS }
      it { should include(hook) }
    end
  end

  describe 'When display message' do
    context 'without arguments' do
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

  describe 'When parse result' do
    %w!Autotest Autotest::Rails!.each do |name|
#TODO: Fill out.
    end

    %w!Autotest::Rspec Autotest::Rspec2 Autotest::RailsRspec Autotest::RailsRspec2 Autotest::MerbRspec!.each do |name|
      context "With #{name}, 2 of 3 examples feiled" do
        subject { Autotest::Tmux.parse_output('3 examples, 2 failures', name) }
        it { should eql({:message => 'Fail F:2 P:0', :color => :red}) }
      end

      context "With #{name}, 1 of 2 examples feiled" do
        subject { Autotest::Tmux.parse_output('2 examples, 1 failure', name) }
        it { should eql({:message => 'Fail F:1 P:0', :color => :red}) }
      end

      context "With #{name}, 1 of 1 example feiled" do
        subject { Autotest::Tmux.parse_output('1 example, 1 failure', name) }
        it { should eql({:message => 'Fail F:1 P:0', :color => :red}) }
      end

      context "With #{name}, 2 of 3 examples pending and 1 failed" do
        subject { Autotest::Tmux.parse_output('3 examples, 1 failure, 2 pendings', name) }
        it { should eql({:message => 'Fail F:1 P:2', :color => :red}) }
      end

      context "With #{name}, 1 of 2 examples pending and 1 failed" do
        subject { Autotest::Tmux.parse_output('2 examples, 1 failure, 1 pending', name) }
        it { should eql({:message => 'Fail F:1 P:1', :color => :red}) }
      end

      context "With #{name}, 2 of 3 examples pending" do
        subject { Autotest::Tmux.parse_output('3 examples, 0 failures, 2 pendings', name) }
        it { should eql({:message => 'Pend F:0 P:2', :color => :yellow}) }
      end

      context "With #{name}, 1 of 2 examples pending" do
        subject { Autotest::Tmux.parse_output('2 examples, 0 failures, 1 pending', name) }
        it { should eql({:message => 'Pend F:0 P:1', :color => :yellow}) }
      end

      context "With #{name}, all examples passed" do
        subject { Autotest::Tmux.parse_output('2 examples, 0 failures', name) }
        it { should eql({:message => 'All Green', :color => :green}) }
      end

      context "With #{name}, all examples passed" do
        subject { Autotest::Tmux.parse_output('1 example, 0 failures', name) }
        it { should eql({:message => 'All Green', :color => :green}) }
      end

			context "With #{name}, a syntax error occured" do
				error = "syntax error, unexpected $end, expecting keyword_end (SyntaxError)"
				subject { Autotest::Tmux.parse_output(error, name) }
				it { should eql({:message => 'Unable to run tests', :color => :red}) }
			end
    end

    context 'With FooBar' do
      subject { Autotest::Tmux.parse_output('1 example, 0 failures', 'FooBar') }
      it { should eql({:message => 'Unknown class. (FooBar)'}) }
    end
  end

  after(:all) do
    Autotest::Tmux.clear
  end
end
