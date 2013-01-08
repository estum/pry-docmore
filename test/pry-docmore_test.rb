require './test/test_helper'

class Pry::DocmoreTest < MiniTest::Unit::TestCase
  def assert_each_explained args
    description = " should be explained as a #{args[:label]}"
    args[:cases].each do |e|
      e[:items].each do |v|
        assert_match /.+/, Pry::Docmore.explain(v), v + description
      end
    end
  end

  def test_keywords
    assert_each_explained \
      label: 'Keyword',
      cases: [
        {
          source: "http://www.zenspider.com/Languages/Ruby/QuickRef.html#reserved-words",
          items: %w(
        alias   and     BEGIN   begin   break   case    class   def     defined?
        do      else    elsif   END     end     ensure  false   for     if
        in      module  next    nil     not     or      redo    rescue  retry
        return  self    super   then    true    undef   unless  until   when
        while   yield)
        },
        {
          source: 'http://krijnhoetmer.nl/stuff/ruby/keywords/',
          items: %w(alias and BEGIN begin break case class def defined? do else
  elsif END end ensure false for if in module next nil not or redo rescue retry
  return self super then true undef unless until when while yield)
        },
        {
          source: 'ruby source, lex.c, circa line 219',
          items: %w(alias and begin BEGIN break case class def defined?  do
  else elsif __ENCODING__ end END ensure false __FILE__ for if in __LINE__
  module next nil not or redo rescue retry return self super then true undef
    unless until when while yield)
        },
      ]
  end

  def test_globals
    assert_each_explained \
      label: 'Global Variable',
      cases: [
        {
          source: 'http://www.zenspider.com/Languages/Ruby/QuickRef.html#pre-defined-variables',
          items: %w(
          $! $@ $& $` $' $+ $1 $~ $= $/ $\\ $, $; $. $< $> $_ $0 $* $$ $? $: $"
          $DEBUG $FILENAME $LOAD_PATH $stderr $stdin $stdout $VERBOSE $-0 $-a
          $-d $-F $-i $-I $-l $-p $-v $-w)
        },
        {
          source: 'ruby -e "p global_variables.map(&:to_s)"',
          items: %w($; $-F $@ $! $SAFE $~ $& $` $' $+ $= $KCODE $-K $" $/ $-0
          $\\ $_ $stdin $stdout $stderr $> $< $. $FILENAME $-i $* $? $$ $: $-I
          $LOAD_PATH $\\ $LOADED_FEATURES $VERBOSE $-v $-w $-W $DEBUG $-d $0
          $PROGRAM_NAME $-p $-l $-a $1 $2 $3 $4 $5 $6 $7 $8 $9)
        },
      #  {
      #    source: 'pry: ls -g',
      #    items: `echo 'lg -g' | pry`.split /\s+/
      #  }
      ]

  end

# TODO - regex syntax!

end

__END__
::::::::::::::
input/dollarvars
::::::::::::::
	  case '_':		/* $_: last read line string */
	    c = nextc();
	    if (parser_is_identchar()) {
		tokadd('$');
		tokadd('_');
		break;
	    }
	    pushback(c);
	    c = '_';
	    /* fall through */
	  case '~':		/* $~: match-data */
	  case '*':		/* $*: argv */
	  case '$':		/* $$: pid */
	  case '?':		/* $?: last status */
	  case '!':		/* $!: error string */
	  case '@':		/* $@: error position */
	  case '/':		/* $/: input record separator */
	  case '\\':		/* $\: output record separator */
	  case ';':		/* $;: field separator */
	  case ',':		/* $,: output field separator */
	  case '.':		/* $.: last read line number */
	  case '=':		/* $=: ignorecase */
	  case ':':		/* $:: load path */
	  case '<':		/* $<: reading filename */
	  case '>':		/* $>: default output handle */
	  case '\"':		/* $": already loaded files */
	    tokadd('$');
	    tokadd(c);
	    tokfix();
	    set_yylval_name(rb_intern(tok()));
	    return tGVAR;

	  case '-':
	    tokadd('$');
	    tokadd(c);
	    c = nextc();
	    if (parser_is_identchar()) {
		if (tokadd_mbchar(c) == -1) return 0;
	    }
	    else {
		pushback(c);
	    }
	  gvar:
	    tokfix();
	    set_yylval_name(rb_intern(tok()));
	    return tGVAR;

	  case '&':		/* $&: last match */
	  case '`':		/* $`: string before last match */
	  case '\'':		/* $': string after last match */
	  case '+':		/* $+: string matches last paren. */
	    if (last_state == EXPR_FNAME) {
		tokadd('$');
		tokadd(c);
		goto gvar;
	    }
	    set_yylval_node(NEW_BACK_REF(c));
	    return tBACK_REF;

	  case '1': case '2': case '3':
	  case '4': case '5': case '6':
	  case '7': case '8': case '9':
	    tokadd('$');
	    do {
		tokadd(c);
		c = nextc();
	    } while (c != -1 && ISDIGIT(c));
	    pushback(c);
	    if (last_state == EXPR_FNAME) goto gvar;
	    tokfix();
	    set_yylval_node(NEW_NTH_REF(atoi(tok()+1)));
	    return tNTH_REF;

	  default:
	    if (!parser_is_identchar()) {
		pushback(c);
		return '$';
	    }
	  case '0':
	    tokadd('$');
	}
	break;
::::::::::::::
input/tokenlist
::::::::::::::
