module chat.loop;

import intuit;
import std.stdio : writeln;
import config.key;
import log;
import chat.tools;
import chat.loop.custom_tools;

void start() {
  auto or_key = new ApiKey("OPENROUTER_KEY");

  auto ep = new OpenAI(
    "https://openrouter.ai/api",
    or_key.get()
  );

  ep.tools.add!shellCmd();
  ep.tools.add!endConversation();
  ep.tools.add!readFile();
  ep.tools.add!listCustomTools();

  auto ctx = new Context();

  bool calledTool = false;

  while (true) { try {
    if (!calledTool) ctx.user(log.input());

    calledTool = false;

    auto result = completions(
      ep,
      "openrouter/free",
      ctx
    );

    if (result.choice.toolCalls.length == 0) {
      writeln(result.text);
      continue;
    }

    foreach (call; result.choice.toolCalls) {
      auto tool = ep.tools.get(call.name);
      auto output = tool.impl(call.arguments);

      ctx.tool(call.id, output);
      log.ok("Called " ~ call.name);
      calledTool = true;
    }
  } catch (Exception e) {
    log.error(e.msg);
  } }
}
