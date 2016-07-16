// load data in ./tag_results.txt and tranfer the second line to number
// then we can load them by function dataread in matlab
// a-->0, b-->1, c-->2, ..., z-->25

#include <iostream>
#include <fstream>
#include <string>
using namespace std;


int main()
{
    ifstream fin("./tag_results.txt");
    ofstream fout("./tag_results_new");
    
    int idx;
    string str;
    
    for (int i = 0; i < 4437; ++i) {
        fin >> idx >> str;
        if (str == "err") continue;
        
        int ans = int(str[0]) - 97;
        
        fout << idx << " " << ans << endl;
    }

    fin.close();
    fout.close();

    return 0;
}