module chat.tools;

import intuit;
import log;

@Description("End the conversation.")
string endConversation() {
  log.panic("Conversation ended.");

  // not reached
  return "";
}

@Description("Read a file.")
string readFile(string name) {
  import std.file : readText;
  try {
    return readText(name);
  } catch (Exception e) {
    log.error("Failed to read file: " ~ e.msg);
    return e.msg;
  }
}
