#ifndef _perf_h_
#define _perf_h_

#include <valgrind/callgrind.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <iomanip>

#include "callgrind-wrapper/callgrind-wrapper.h"

//using namespace callgrind_wrapper;

struct Startup
{
    Startup()
      {
	if (!callgrind_wrapper::is_working())
	  {
	    std::cout << "ERROR: please run within callgrind (using 'make run' should work)!" << std::endl;
	    //std::abort();
	  }
      }
    
} startup;


  class Instrument
  {
  public:
    Instrument(const char *name)
      :
      name (name),
      stopped(false)
    {
      callgrind_wrapper::reset();
    }

    void stop()
    {
      long cycles = callgrind_wrapper::current();
      stopped = true;

      std::cout << "> " << name << " " << std::fixed << std::setprecision(6)
		<< static_cast<double>(cycles)/1000000.0 << std::endl;
    }

    ~Instrument()
    {
      if (!stopped)
        stop();
    }

  private:
    const char *name;
    bool stopped;
  };


/*
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

  private:
    const char* name;
    bool stopped;
};
*/
#endif
