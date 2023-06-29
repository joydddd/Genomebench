void pin_start() asm("pin_hook_init");
void pin_stop() asm("pin_hook_fini");
__attribute_noinline__ void pin_start() {fprintf(stderr, "PIN START\n");}
__attribute_noinline__ void pin_stop() { fprintf(stderr, "PIN END\n"); }