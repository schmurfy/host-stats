#include <ruby.h>
#include <limits.h>

static VALUE maxpathlen(VALUE self)
{
  uint32_t ret;
  
#if defined(PATH_MAX)
  ret = PATH_MAX;
#elif defined(MAXPATHLEN)
  ret = MAXPATHLEN;
#else
  ret = 4096;
#endif
  
  return UINT2NUM(ret);
}

/* ruby calls this to load the extension */
void Init_hoststats(void)
{
  /* assume we haven't yet defined Hola */
  VALUE mod = rb_define_module("HostStats");

  /* the hola_bonjour function can be called
   * from ruby as "Hola.bonjour" */
  rb_define_singleton_method(mod, "maxpathlen", maxpathlen, 0);
}
