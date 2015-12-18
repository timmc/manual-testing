# Manual software testing toolkit

This is a collection of techniques and tests I find myself using when
I evaluate software for security problems and other bugs. Some items
are pretty self-explanatory, others are a bit more opaque. Many of
these can be done without much technical knowledge, which is part of
why I'm publishing this list. I hope you find this helpful!

- For all text input fields, test roundtripping and display of:
    - Empty
    - Blank (just whitespace)
    - Null character in middle of text
    - Non-ASCII, such as ☃
    - Astral Unicode characters, such as 𐀀
    - Syntax characters for URLs, HTML, SQL, etc.: `~#$%&*+\\|<>;"'?/={}[]*`
        - If any of these fail to validate and roundtrip, probably
          indicates poor coding and possibly a security bug around
          panicked handling of syntax characters (instead of actually
          escaping outputs properly.)
    - Control code characters
- Security problems due to language embedding:
    - Does `</script>` break out of JSON embedded in HTML?
    - Does `<xss>` render as HTML? (And similar issues with quotes.)
    - Is SQL injection apparent with quotes and semicolon?
    - Is the site likely to shell out for anything, such as image
      reformatting? Does it escape properly for the shell environment,
      or even avoid escaping?
- Miscellaneous security probes:
    - Does the site's administrative UI (if any) have XSS holes based
      on object names, usernames, or emails?
    - Does the site's analytics UI (if any) have XSS holes based on
      crafted URLs?
    - Attack reflection: Can I make the site make requests on my
      behalf to other sites?  Is there a multiplier effect such as
      being in proportion to the number of users viewing an object?
      Can I trigger it anonymously?
    - Is GET only used for non-side-effecting operations? (E.g. logout
      link, account or object deletion)
    - Is there CSRF protection on side-effecting operations? (Am I
      protected from POSTs from off-site?)
    - Does URL-guessing get me access to other people's objects?
- Object lifecycle
    - When I delete an object, is it still referenced anywhere?
    - Do deleted objects free up names in registries? (Can I reclaim a
      name or ID?)
    - Is it still possible to view or edit a "deleted" object if I
      still have its ID or other reference?
    - Are ID collisions possible in places where user can set ID of
      objects? What about across users?
- Smells
    - Looking at source code, are there places where a too-powerful
      language is used, such as HTML where text would suffice?
    - Is user input echoed in error messages anywhere?
- Special URL issues:
    - Does user input end up as URL path components? Try `.` or `..`
      alone for path traversal, and `/`, `%`, and `+` anywhere in a
      string for escaping issues.
- Special display problems:
    - Bidi overrides, such as RLO character (is user input contained
      in bidi embeds)
    - Empty fields -- do they cause formatting issues such as collapses?
    - Really loooong values -- do they overflow their containers or
      push them open?
        - What about long values with no spaces that would allow for
          word-wrapping?
- Leaks
    - Can I post links to remote assets that will reveal another
      user's IP address to me as they view it?
- CMS problems
    - Objects with empty titles -- is it still possible to click to edit them?
- Validation of various fields
    - Does it happen on client side, server, or both?
        - If both, is it consistent?
    - When only numerals are permitted, what happens when I use
      Devanagari numerals (or other non-Arabic numerals)
      http://www.fileformat.info/info/unicode/category/Nd/list.htm
- HTTPS enabled?
    - Strict-Transport-Security enabled?
    - Are there places where a redirect is not in places?
- Email:
    - Can I engage in header splitting or SMTP injection to redirect email?
    - Is the email address validator overly permissive? (Permitting
      newline and other dangerous chars that no longer have a valid
      use.)
    - Is the email address validator overly restrictive? (Blocking `+`
      and other valid chars; blocking punycode domain names; blocking
      domains ending in `.` (absolute domains).)
    - Is HTML escaping done properly in emails?
    - Check unicode support in subject lines, where user input accepted
