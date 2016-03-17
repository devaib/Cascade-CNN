#include <opencv2/opencv.hpp>
#include <iostream>
#include <fstream>
#include <vector>

using namespace std;
using namespace cv;

void writeMatToFile(cv::Mat& m, const char* filename)
{
    ofstream fout(filename);

    if(!fout)
    {
        cout<<"File Not Opened"<<endl;  return;
    }

    for(int i=0; i<m.rows; i++)
    {
        for(int j=0; j<m.cols; j++)
        {
            fout << m.at<float>(i,j) << "\t";
        }
        fout<<endl;
    }

    fout.close();
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
