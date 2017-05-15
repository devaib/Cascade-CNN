#pragma once

#include <stdlib.h>
#include <stdio.h>
#include <opencv2/core/core_c.h>
#include <opencv2/highgui/highgui_c.h>
#include <string.h>
#include <math.h>

//#define max(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b;})
//#define min(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a < _b ? _a : _b;})
#define max(a, b)	(((a) > (b)) ? (a) : (b));
#define min()

typedef int bool;
#define true 1
#define false 0

extern const char FILE_PATH[];

struct Windows{
    int x1, y1, x2, y2;         // image coordinates
    float score;                // 12 layer score
    float iou;                  // iou ratio
    bool dropped;               // if this window is dropped
};
