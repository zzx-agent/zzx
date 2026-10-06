module config.key;
import log;

class ApiKey {
  import std.process : environment;

public:
  this(string envvar_name) {
    data = environment.get(envvar_name);
    if (data == "") {
      log.panic(envvar_name ~ " not provided.");
    }
  }

  string get() {
    return data;
  }

private:
  string data;
}
