module chat.loop;

import intuit;
import std.stdio : writeln;
import key;
import log;
import chat.tools;

void start() {
  auto or_key = new ApiKey("OPENROUTER_KEY");

  auto ep = new OpenAI(
    "https://openrouter.ai/api",
    or_key.get()
  );

  ep.tools.add!endConversation();
  ep.tools.add!readFile();

  auto ctx = new Context();

  bool calledTool = false;

  while (true) {
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
  }
}
