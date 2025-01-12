
int main(int argc, char* argv[]) {
  int* array = new int[argc + 1];
  // neglect delete to trigger leak sanitizer
  return array[0];
}
