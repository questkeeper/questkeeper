#include "application.hpp"

int main(const int argc, char** argv) {
  const auto app = my_application_new();

  return g_application_run(G_APPLICATION(app), argc, argv);
}
