static __noinline uint64_t addsb_iter(uint64_t x, uint64_t y) {
	uint64_t r = 0;
	for (int i = 0; i < 64; i += 8) {
    	int xb = (int8_t)(x >> i);
    	int yb = (int8_t)(y >> i);
    	int rb = xb + yb;
    	if (rb > INT8_MAX)
    		rb = INT8_MAX;
		if (rb < INT8_MIN)
			rb = INT8_MIN;
		r |= (uint64_t)(rb & 255) << i;
  	}
	return r;
}