module chat.tools;

import intuit;
import log;

@Description("End the conversation.")
string endConversation(string reason) {
  log.panic("Conversation ended. " ~ reason);

  // not reached
  return "";
}

@Description("Read a file.")
string readFile(string name) {
  import std.file : readText;

  log.verbose(name);

  try {
    return readText(name);
  } catch (Exception e) {
    log.error("Failed to read file: " ~ e.msg);
    return e.msg;
  }
}

@Description("Run a shell command.")
string shellCmd(string cmd) {
  import std.process : executeShell;
  import std.conv : to;

  log.verbose(cmd);

  try {
    auto proc = executeShell(cmd);
    return proc.output ~ "\n>> Exited with " ~ to!string(proc.status);
  } catch (Exception e) {
    log.error("Failed to execute command: " ~ e.msg);
    return e.msg;
  }

  return "";
}
