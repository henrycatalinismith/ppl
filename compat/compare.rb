#!/usr/bin/env ruby
# Runs identical command sequences against the Ruby and Rust implementations
# and reports any difference in stdout, stderr, exit status, the .vcf files
# they write, or the git commits they make.
#
#   ruby compat/compare.rb [path/to/rust/ppl]

require "open3"
require "shellwords"
require "tmpdir"

ROOT = File.expand_path("..", __dir__)
RUBY_PPL = File.join(ROOT, "bin", "ppl")
RUST_PPL = ARGV[0] || File.join(ROOT, "target", "debug", "ppl")

SETUP = ["init", "add bob 'Bob Smith'"]

SCENARIOS = {
  "help and usage" => [
    "", "help", "frob", "help -x", "help --help", "version", "ls --help", "ls -h",
    "ls --version", "email --bogus", "post --p x", "email bob --delete=x", "phone bob -t",
    "post --help", "name --help", "nick --help", "mutt --help", "scrape --help",
    "show", "add", "add x", "mv", "mv bob", "rm", "completion", "completion fish",
    "completion bash", "completion zsh", "nick bob --no-delete y", "version --bogus",
    "bday --help", "url --help", "org --help", "age --help",
  ],
  "contacts" => [
    "add alice 'Alice Adams'", "add carol Carol", "ls", "show bob", "show nobody",
    "mv bob robert", "ls", "mv robert alice", "rm carol", "ls", "rm carol", "name",
  ],
  "names" => [
    "name bob", "name bob 'Robert Smith'", "name bob", "name bob -g Rob -f Smithers -m Q",
    "name bob -p Dr --suffix Jr", "show bob", "name", "add blank ''", "name blank",
    "show blank", "name blank -g Only", "name blank", "add spaces '  '", "show spaces",
  ],
  "emails" => [
    "email bob bob@example.org", "email bob bob@work.example", "email bob",
    "email bob bob@work.example --preferred", "email bob", "ls",
    "email bob bob@work.example -P", "email bob", "email bob new@x.org -p", "email",
    "email bob --format '%f%a'", "email bob -d bob@example.org", "email bob", "show bob",
    "email bob ''", "email nobody x@y",
  ],
  "phones" => [
    "phone bob 0123", "phone bob 0456 --type cell", "phone bob", "phone bob 0123 -t home",
    "phone bob 0456 -p", "phone bob", "phone bob 0456 -P", "phone", "phone bob -d 0123",
    "phone bob", "show bob", "phone bob 789 -tWork", "phone bob",
  ],
  "postal addresses" => [
    "post bob home --street '1234 Testing Avenue' --postal-code 'AB1 2CD'",
    "post bob work --street '987 Working Road' -z 'EF3 4GH' -c UK -r Region -l Town",
    "post bob", "post bob work --preferred", "post bob", "post bob work", "post bob nope",
    "post", "post bob work -m office", "post bob", "post bob office -m home",
    "post bob office -P", "post bob home -d", "post bob", "post bob home -d", "show bob",
    "post bob 'Odd;Id' -s 'a, b; c'", "post bob", "post bob Odd\\;Id",
  ],
  "attributes" => [
    "nick bob bobby", "nick bob bo", "nick bob", "nick", "nick --no-color",
    "nick bob -d bobby", "nick bob", "org bob Acme", "org bob 'Widgets, Inc'", "org bob",
    "org", "org bob -d Acme", "url bob http://example.org", "url bob https://x.y/z?a=b",
    "url bob", "url", "url bob -d http://example.org", "show bob",
  ],
  "birthdays" => [
    "bday bob", "bday bob 1980-02-03", "bday bob", "bday", "age bob", "age",
    "bday bob 'February 4, 1981'", "bday bob", "bday bob 13/02/1980", "bday bob",
    "bday bob notadate", "bday bob 1980-02-30", "show bob", "ls --format '%i %b %a'",
  ],
  "custom formats" => [
    "email bob b@x.org", "phone bob 123", "nick bob bobby", "org bob Acme",
    "ls --format '%i: %N <%e> %p %k %o%n'", "ls --format '[%10i|%-10N]'",
    "ls --format '%z %% %'", "ls -f %i", "ls --form %i/%N", "ls --FORMAT %i", "ls -p x",
  ],
  "mutt" => [
    "mutt", "mutt bob", "email bob bob@example.org", "email bob robert@work.org",
    "add alice 'Alice Adams'", "email alice alice@example.org", "mutt bob", "mutt Bob",
    "mutt BOB", "mutt -i BOB", "mutt example", "mutt work", "mutt zzz",
  ],
  "long values" => [
    "name bob '#{"Bartholomew " * 10}'", "url bob 'http://example.org/#{"a" * 200}'",
    "show bob", "url bob",
  ],
  "unicode" => [
    "add zoe 'Zoë Ångström'", "email zoe zoë@exämple.org", "nick zoe 'Zö'", "ls", "show zoe",
    "nick", "mutt -i ZOË",
  ],
  "options" => [
    "email bob a@b.c", "email bob --no-preferred a@b.c", "email bob", "email bob --pref a@b.c",
    "email bob", "email bob -pd", "email bob --dele a@b.c", "email bob", "email bob x@y -xd",
    "email bob x@y --del=1", "phone bob 1 --ty", "phone bob 1 --ty=home", "phone bob",
    "post bob h --po-box 12 --postal_code Z1", "post bob", "nick bob --colr",
    "phone bob --typ", "mutt --i x", "name bob --pre Sir", "show bob", "ls --pre x",
    "post bob h -p", "post bob", "email bob -- -weird", "email bob",
  ],
  "config" => [
    "!mkdir -p .home book && printf '[address book]\npath = book ; comment\n[alias]\nl = ls\nn = !echo hello\nbad = nope\n[pretty]\nshort = %%i\nnum = 42\n' > .home/.pplconfig",
    "init book", "add amy Amy", "!ls book", "l", "n", "n there", "bad", "ls --pretty short",
    "ls --pretty missing", "ls --pretty num", "nick --no-color",
  ],
  "xdg config" => [
    "!mkdir -p .home/.config/ppl && printf '[pretty]\nlong = %%N\n' > .home/.config/ppl/config",
    "ls --pretty long",
  ],
  "disk address book" => [
    :no_setup, "add bob Bob", "!ls -a", "email bob b@x", "ls", "show bob", "mv bob rob",
    "ls", "rm rob", "ls", "!printf 'garbage' > bad.vcf", "ls", "show bad",
  ],
  "foreign vcards" => [
    "!printf 'BEGIN:VCARD\r\nVERSION:2.1\r\nN:Doe;Jane;;Ms.;\r\nFN:Jane Doe\r\nEMAIL;INTERNET;PREF:jane@x.org\r\nitem1.EMAIL;type=INTERNET:other@x.org\r\nTEL;WORK;VOICE:+1 555\r\nTEL;TYPE=CELL,x-custom:+1 666\r\nADR;HOME:;;1 Main St;Town;ST;12345;USA\r\nADR:;;No Label St;;;;\r\nORG:Acme\\, Inc;Sales\r\nNICKNAME:JD,Janey\r\nBDAY:1975-12-25T00:00:00Z\r\nURL;type=WORK:http://x.org\r\nNOTE;ENCODING=QUOTED-PRINTABLE:caf=C3=A9\r\nX-FOO:bar\r\n long continuation\r\nEND:VCARD\r\n' > jane.vcf && git add jane.vcf && git commit -qm jane",
    "ls", "show jane", "email jane", "phone jane", "post jane", "org jane", "nick jane",
    "bday jane", "url jane", "name jane", "email jane new@x.org", "!cat jane.vcf",
    "!printf 'BEGIN:VCARD\nVERSION:3.0\nFN:No N\nEND:VCARD\n' > non.vcf && git add non.vcf && git commit -qm non",
    "show non", "ls",
    "!printf '\xef\xbb\xbfBEGIN:VCARD\nVERSION:3.0\nN:;Bom;;;\nBDAY:19990231\nEND:VCARD\n' > bom.vcf && git rm -q non.vcf && git add bom.vcf && git commit -qm bom",
    "show bom", "!printf 'BEGIN:VCARD\nVERSION:3.0\nN:;Bom;;;\nBDAY:not-a-date\nEND:VCARD\n' > bom.vcf && git commit -qam bom2",
    "show bom", "!printf 'BEGIN:VCARD\nN:;X;;;\nEND:VCARX\n' > bom.vcf && git commit -qam bom3",
    "show bom", "!printf 'N:;X;;;\n' > bom.vcf && git commit -qam bom4", "show bom",
    "!printf '' > bom.vcf && git commit -qam bom5", "show bom",
  ],
  "uncommitted changes are ignored in git mode" => [
    "!printf 'BEGIN:VCARD\nVERSION:3.0\nN:;Ghost;;;\nFN:Ghost\nEND:VCARD\n' > ghost.vcf",
    "ls", "show ghost",
  ],
  "scrape" => [
    %q(!printf 'From: "Jane Doe" <jane@x.org>\nTo: me@x.org\nSubject: hi\n\nbody\n' | $PPL scrape -q -s),
    %q(!printf 'From: "Jane Doe" <jane2@x.org>\nSubject: hi\n\nbody\n' | $PPL scrape -qs),
    "!printf 'From: =?UTF-8?Q?Zo=C3=AB?= <zoe@x.org>\n\nbody\n' | $PPL scrape -q --sender",
    "!printf 'From: anon@x.org\n\nbody\n' | $PPL scrape -q -s",
    "!printf 'From: anon@x.org\n\nbody\n' | $PPL scrape -q", "ls", "show jane_doe_1",
  ],
  "shell" => [
    %q(!printf 'add x X\nls\n\nemail x x@y\nexit\nls\n' | $PPL shell > /dev/null), "ls", "email x",
  ],
  "grep" => [
    "email bob bob@example.org", "grep example", "grep nothing-matches",
  ],
}

def run(ppl, dir, command, env)
  command = command.start_with?("!") ? command[1..] : "#{ppl} #{command}"
  out, err, status = Open3.capture3(env.merge("PPL" => ppl), command, chdir: dir)
  [out, err, status.exitstatus]
end

def snapshot(dir)
  files = Dir.glob(File.join(dir, "*.vcf")).sort.map { |f| [File.basename(f), File.read(f)] }
  log, = Open3.capture3("git", "log", "--format=%s", chdir: dir)
  [files, log]
end

def scenario(name, commands)
  failures = []
  results = [RUBY_PPL, RUST_PPL].map do |ppl|
    Dir.mktmpdir do |dir|
      dir = File.realpath(dir)
      home = File.join(dir, ".home")
      Dir.mkdir(home)
      env = {"HOME" => home, "XDG_CONFIG_HOME" => File.join(home, ".config")}
      steps = commands.first == :no_setup ? commands.drop(1) : SETUP + commands
      outputs = steps.map { |c| [c, run(ppl, dir, c, env)] }
      [outputs, snapshot(dir)]
    end
  end
  (ruby_outputs, ruby_files), (rust_outputs, rust_files) = results
  ruby_outputs.zip(rust_outputs).each do |(command, expected), (_, actual)|
    next if expected == actual
    failures << "  $ ppl #{command}\n" +
      ["stdout", "stderr", "status"].each_with_index.map { |label, i|
        next if expected[i] == actual[i]
        "    #{label}:\n      ruby: #{expected[i].inspect}\n      rust: #{actual[i].inspect}"
      }.compact.join("\n")
  end
  ruby_files[0].zip(rust_files[0]).each do |expected, actual|
    next if expected == actual
    failures << "  file differs:\n    ruby: #{expected.inspect}\n    rust: #{actual.inspect}"
  end
  failures << "  git log differs:\n    ruby: #{ruby_files[1].inspect}\n    rust: #{rust_files[1].inspect}" if ruby_files[1] != rust_files[1]
  failures << "  file count differs" if ruby_files[0].length != rust_files[0].length
  failures
end

only = ENV["ONLY"]
total = 0
SCENARIOS.each do |name, commands|
  next if only && !name.include?(only)
  failures = scenario(name, commands)
  total += failures.length
  puts failures.empty? ? "ok   #{name}" : "FAIL #{name}\n#{failures.join("\n")}"
end
exit(total.zero? ? 0 : 1)
