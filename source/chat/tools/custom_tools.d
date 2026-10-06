module chat.loop.custom_tools;

import intuit;

class Tools {
  import std.path : expandTilde, absolutePath;
  import std.file : mkdirRecurse, dirEntries, SpanMode, mkdirRecurse;

public:
  this() {
    main_path = expandTilde("~/.config/zzx/");
    mkdirRecurse(main_path);

    foreach (e; dirEntries(main_path, SpanMode.depth)) {
      paths ~= absolutePath(e.name);
    }
  }

  string[] paths;

private:
  string main_path;
}

Tools t;
shared static this() {
  t = new Tools;
}

@Description(
  "List all custom tools; use this if the user asks for usage of a tool " ~
  "you do not recognize, then run your selected path as a shell script"
) string listCustomTools() {
  import std.array : join;
  return t.paths.join(", ");
}
