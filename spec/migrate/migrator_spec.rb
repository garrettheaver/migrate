require_relative '../../lib/migrate'

describe Migrate::Migrator do

  subject do
    Migrate::Migrator.new(db)
  end

  let(:db) do
    double('db').tap do |db|
      allow(db).to receive(:transaction) { |&b| b.call }
      allow(db).to receive(:uri) { ':double:' }
    end
  end

  describe '#execute' do

    it 'raises an error if the path does not exist' do
      expect{ subject.execute('/no.file') }.to raise_error(ArgumentError)
    end

    it 'reads and runs .sql file contents against the db' do
      Tempfile.create(['test', '.sql']) do |file|
        file.write('-- SQL')
        file.close

        expect(db).to receive(:<<).with('-- SQL')
        subject.execute(file.path)
      end
    end

    it 'runs +x files passing the db uri as the first argument' do
      Tempfile.create(['test', '.sh']) do |file|
        file.write('printf $1')
        file.chmod(0777)

        file.close
        expect(subject.execute(file.path)).to eq(db.uri)
      end
    end

    it 'raises an error when a +x file has a non zero exit code' do
      Tempfile.create(['test', '.sh']) do |file|
        file.write('exit 1')
        file.chmod(0777)

        file.close
        expect{ subject.execute(file.path) }.to raise_error(RuntimeError)
      end
    end

    it 'raises an error on invalid files' do
      Tempfile.create(['test', '.unknown']) do |file|
        expect{ subject.execute(file.path) }.to raise_error(ArgumentError)
      end
    end

  end

end

