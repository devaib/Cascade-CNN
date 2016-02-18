#include <vector>
#include <iostream>
#include <fstream>
#include "storage.h"
using namespace cnn;
using namespace cv;
using namespace std;

const  string CNNLabel::NAME       = "name";
const  string CNNLabel::PARAMS     = "params";
const  string CNNLabel::WEIGHTS    = "weights";
const  string CNNLabel::LAYERS     = "layers";
const  string CNNLabel::BIAS       = "bias";
const  string CNNLabel::TYPE       = "type";
const  string CNNLabel::NETWORK    = "network";
const  string CNNLabel::CNN        = "cnn";


const string CNNParam::PadH = "padH";
const string CNNParam::PadW = "padW";
const string CNNParam::StrideH = "sH";
const string CNNParam::StrideW = "sW";
const string CNNParam::KernelW = "kW";
const string CNNParam::KernelH = "kH";


const string CNNOpType::CONV = "conv";
const string CNNOpType::RELU = "relu";
const string CNNOpType::NORM = "norm";
const string CNNOpType::SOFTMAX = "softmax";
const string CNNOpType::MAXPOOL = "maxpool";
const string CNNOpType::FC      = "fc";



void readMats(size_t amount, size_t rows, size_t cols, size_t depth, ifstream &f, vector<Mat> &mats)
{
    Ptr<float> buffer = new float[amount*depth*rows*cols];
    f.read((char*)((float*)buffer), amount*rows*cols*depth*sizeof(float));
    mats.resize(amount * depth);
    for (size_t i = 0; i < amount; i++)
    {
        for (size_t j = 0; j < depth; j++){
            mats[i*depth + j] = Mat(rows,cols, CV_32F, &buffer[(i*depth+j)*rows*cols]).t();
        }
    }
}

void readVector(size_t amount, ifstream &f, vector<float> &vector)
{
    vector.resize(amount);
    f.read((char*)&vector[0], amount * sizeof(float));
}


void Layer(){};

void Layer(string type, vector<float> params, const string &filename, Filter filter, Bias bias)
{
    this.type = type;

    this.setParam(cnn::CNNParam::PadH, params[0]);
    this.setParam(cnn::CNNParam::PadW,   params[1]);
    this.setParam(cnn::CNNParam::StrideW, params[2]);
    this.setParam(cnn::CNNParam::StrideH,  params[3]);
    this.setParam(cnn::CNNParam::KernelH, params[4]);
    this.setParam(cnn::CNNParam::KernelW, params[5]);

    ifstream f(filename, ios::in | ios::binary);
    readMats(filter.amount, filter.width, filter.height, filter.depth, f, this.weights);
    readVector(bias.amount, f, this.bias);

}

void Layer::setParam(const string &param, float value)
{
    params[param] = value;
}
void Layer::write(FileStorage &fs) const
{
    fs << "{";
    fs << CNNLabel::TYPE    <<  type;
    fs << CNNLabel::WEIGHTS << "[" ;
    for (size_t i = 0; i < weights.size(); i++)
    {
        fs << weights[i];
    }
    fs <<"]";
    fs << CNNLabel::BIAS << "[";
    for (size_t i = 0; i < bias.size(); i++)
    {
        fs << bias[i];
    }
    fs <<"]";
    fs << CNNLabel::PARAMS << "{";

    for (std::map<string,float>::const_iterator it=params.begin(); it!=params.end(); ++it)
        fs << it->first << it->second;

    fs << "}";
    fs <<"}";

}
void Layer::read(const FileNode& node)
{
    weights.clear();
    bias.clear();
    type = (string)node[CNNLabel::TYPE];
    FileNode n = node[CNNLabel::WEIGHTS];
    if (n.type() == FileNode::SEQ)
    {
        FileNodeIterator it = n.begin(), it_end = n.end();
        for (; it != it_end; ++it)
        {
            Mat tmp;
            *it >> tmp;
            weights.push_back(tmp);
        }
    }
    FileNode n2 = node[CNNLabel::BIAS];
    if (n2.type() == FileNode::SEQ)
    {
        FileNodeIterator it = n2.begin(), it_end = n2.end();
        for (; it != it_end; ++it)
        {
            float tmp;
            *it >> tmp;
            bias.push_back(tmp);
        }
    }
    FileNode n3 = node[CNNLabel::PARAMS];
    if (n3.type() == FileNode::MAP)
    {
        FileNodeIterator it = n3.begin(), it_end = n3.end();
        for (; it != it_end; ++it)
        {
            string name = (*it).name();
            int value;
            (*it) >> value;
            params[name] = value;

        }
    }

}

string CNN::generateLayerName(const string &type)
{
    size_t layerN = _layers.size();
    string name   = to_string(layerN) + "." +  _name + "." + type;
    return name;
}


Layer& CNN::getLayer(const string &name)
{
    return _layers[_map.at(name)];
}

Layer& CNN::addLayer(const Layer &layer)
{
    size_t layerN = _layers.size();
    string name   = generateLayerName(layer.type);

    _map[name] = layerN;
    _layers.push_back(layer);
    _network.push_back(name);
    return _layers[_map.at(name)];
}

void CNN::write(FileStorage &fs) const
{
    fs << "{";
    fs << CNNLabel::NAME << _name;
    fs << CNNLabel::LAYERS << "[";
    for (size_t i = 0; i < _layers.size(); i++)
    {
        fs << _layers[i];
    }
    fs << "]";
    fs << CNNLabel::NETWORK << "[";
    for (size_t i = 0; i < _network.size(); i++)
    {
        fs << _network[i];
    }
    fs << "]";
    fs << "}";
}
void CNN::read(const FileNode &node)
{
    _layers.clear();
    _map.clear();
    _network.clear();
    _name = (string)node[CNNLabel::NAME];
    FileNode n = node[CNNLabel::LAYERS];
    if (n.type() == FileNode::SEQ)
    {
        FileNodeIterator it = n.begin(), end = n.end();
        for (; it != end; it++)
        {
            Layer tmp;
            *it >> tmp;
            addLayer(tmp);
        }
    }
}

Ptr<CNN> CNN::loadCNNFromFile(const string& filename)
{
    Ptr<CNN> tmp = new CNN("");
    FileStorage fs(filename, FileStorage::READ);
    fs[CNNLabel::NAME] >> *tmp;
    fs.release();
    return tmp;
}

void CNN::writeCNNToFile(const CNN &cnn, const string &filename)
{
    FileStorage fs(filename, FileStorage::WRITE);
    fs << CNNLabel::NAME << cnn;
    fs.release();
}



ostream& cnn::operator<<(ostream &out, const Layer& w)
{
    out << "{ "<< endl;
    out << "\t" << CNNLabel::TYPE << ": " << w.type << endl;
    if (w.bias.size())
    {
        cout << "\t" << CNNLabel::BIAS << ": (" << w.bias.size() << ") [";
        for (size_t i = 0; i < w.bias.size(); i++)
            out << w.bias[i] << ((i!=w.bias.size()-1)?", ":"");
        out << "]" << endl;
    }
    if (w.weights.size())
    {
        cout << "\t" << CNNLabel::WEIGHTS << ": ("<< w.weights.size() << ") ["<< endl;
        for (size_t i = 0; i < w.weights.size(); i++)
        {
            out << "\t\t" << w.weights[i].rows<< "x" << w.weights[i].cols;
            if (w.weights[i].channels() > 1)
                out << "x" << w.weights[i].channels() << " ";
            out << w.weights[i].reshape(1,1) << endl;
        }
        out << "\t]" << endl;
    }
    if (w.params.size())
    {
        out << "\t" << CNNLabel::PARAMS << "[";
        for (std::map<string,float>::const_iterator it=w.params.begin(); it!=w.params.end(); ++it)
            cout << it->first <<": "<< it->second << ((it!=(--w.params.end()))?", ":"");
        out << "]" << endl;
    }
    out << "}" << endl;

    return out;
}
ostream& cnn::operator<<(ostream &out, const CNN& w)
{
    cout << CNNLabel::NAME << ": \t\t" << w._name << endl;
    cout << CNNLabel::NETWORK << ": \t";
    for (size_t i = 0; i < w._network.size(); i++)
    {
        out << w._network[i] << ((i<w._network.size()-1)?" -> ":"") ;
    }
    out << endl;
    out << CNNLabel::LAYERS << ": \t[" << endl;
    for (size_t i = 0; i < w._layers.size(); i++)
    {
        out <<  w._layers[i];
        if (i != w._layers.size()- 1)
        {
            out << ", " << endl;
        }
    }
    out << "]" << endl;
    return out;
}
