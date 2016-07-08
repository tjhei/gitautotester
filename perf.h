
#include <valgrind/callgrind.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>


class Instrument
{
  public:

    Instrument(const char* name)
		    :
		    name (name),
		    stopped(false)
      {
	CALLGRIND_START_INSTRUMENTATION;
	CALLGRIND_ZERO_STATS;
      }

    void stop()
      {
	if (stopped)
	  return;
	
	stopped = true;
	int ret;
	ret = system("rm -f log*");
	CALLGRIND_DUMP_STATS_AT(name);
	
	ret = system("cat log* | grep summary >log.summary");

	std::ifstream f("log.summary");
	std::string bla;
	long cycles;
	f >> bla >> cycles;
	std::cout << "> " << name << " " << cycles << std::endl;
	
	ret = system("rm -f log*");
      }

    ~Instrument()
      {
	stop();
      }


    static void summary()
      {
	//	system("ls log*");
	//system("cat log* | egrep 'Trigger|summary'");
	//system("rm log*");//
      }
    

  private:
    const char* name;
    bool stopped;
};


