#include <opencv2/opencv.hpp>
#include <iostream>
#include <fstream>
#include <vector>

using namespace std;
using namespace cv;

static void myResize(Mat &src,
                     Mat dst,
                     long src_start,
                     long dst_start,
                     long src_stride,
                     long dst_stride,
                     long src_len,
                     long dst_len )
{
  if ( dst_len > src_len ){
    long di;
    float si_f;
    long si_i;
    float scale = (float)(src_len - 1) / (dst_len - 1);

    if ( src_len == 1 )
    {
        for( di = 0; di < dst_len - 1; di++ )
        {
            long dst_pos = dst_start + di*dst_stride;
            dst[dst_pos] = src[ src_start ];
        }
    }
    else {
        for( di = 0; di < dst_len - 1; di++ )
        {
            long dst_pos = dst_start + di * dst_stride;
            si_f = di * scale; si_i = (long)si_f; si_f -= si_i;
            
            dst[dst_pos] = image_(FromIntermediate)(
            (1 - si_f) * src[ src_start + si_i * src_stride ] +
            si_f * src[ src_start + (si_i + 1) * src_stride ]);
        }
    }

    dst[ dst_start + (dst_len - 1) * dst_stride ] = src[ src_start + (src_len - 1) * src_stride ];
  }
    
  else if ( dst_len < src_len )
  {
      long di;
      long si0_i = 0; float si0_f = 0;
      long si1_i; float si1_f;
      long si;
      float scale = (float)src_len / dst_len;
      float acc, n;

      for( di = 0; di < dst_len; di++ )
      {
          si1_f = (di + 1) * scale; si1_i = (long)si1_f; si1_f -= si1_i;
          acc = (1 - si0_f) * src[ src_start + si0_i * src_stride ];
          n = 1 - si0_f;
          
          for( si = si0_i + 1; si < si1_i; si++ )
          {
              acc += src[ src_start + si * src_stride ];
              n += 1;
          }
        
          if( si1_i < src_len )
          {
              acc += si1_f * src[ src_start + si1_i*src_stride ];
              n += si1_f;
          }
        
          dst[ dst_start + di*dst_stride ] = image_(FromIntermediate)(acc / n);
          si0_i = si1_i; si0_f = si1_f;
      }
  }
    
  else
  {
      long i;
      for( i = 0; i < dst_len; i++ )
          dst[ dst_start + i*dst_stride ] = src[ src_start + i*src_stride ];
  }
}

int main()
{
    string imageFileName = "../../../test/img/38.png";
    string torchImage[3];
    torchImage[0] = "../torchBicubic.png";
    torchImage[1] = "../torchBilinear.png";
    torchImage[2] = "../torchSimple.png";
    Mat image = imread(imageFileName), opencvNearest, opencvLinear, opencvArea, opencvCubic, opencvLanczos4;
    Mat torchBicubic = imread(torchImage[0]), torchBilinear = imread(torchImage[1]), torchSimple = imread(torchImage[2]);

    resize(image, opencvNearest,  Size(200,300), 0, 0, INTER_NEAREST);
    resize(image, opencvLinear,   Size(200,300), 0, 0, INTER_LINEAR);
    resize(image, opencvArea,     Size(200,300), 0, 0, INTER_AREA);
    resize(image, opencvCubic,    Size(200,300), 0, 0, INTER_CUBIC);
    resize(image, opencvLanczos4, Size(200,300), 0, 0, INTER_LANCZOS4);


    waitKey();
    // imshow("opencvNearest",  opencvNearest);
    // imshow("opencvLinear",   opencvLinear);
    // imshow("opencvArea",     opencvArea);
    // imshow("opencvCubic",    opencvCubic);
    // imshow("opencvLanczos4", opencvLanczos4);
    //
    // imshow("torchBicubic",  torchBicubic);
    // imshow("torchBilinear", torchBilinear);
    // imshow("torchSimple",   torchSimple);

    imwrite("../opencvNearest.png",  opencvNearest);
    imwrite("../opencvLinear.png",   opencvLinear);
    imwrite("../opencvArea.png",     opencvArea);
    imwrite("../opencvCubic.png",    opencvCubic);
    imwrite("../opencvLanczos4.png", opencvLanczos4);

    // writeMatToFile(opencvNearest, "../opencvNearest.csv");

    // opencvCubic.convertTo(opencvCubic, CV_32F);
    // opencvCubic = opencvCubic / 255.f;
    // cout << opencvCubic << endl;


    waitKey();

    return 0;
}
