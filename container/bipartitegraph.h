#ifndef BIPARTITEGRAPH_H
#define BIPARTITEGRAPH_H
#include <list>
#include <iostream>
#include <exception>
#include <string>
#include <vector>
// ofstream constructor.
#include <fstream>


namespace bpg {

    #define THROW_TYPE_EXCEPTION(s) throw Exception(s, __LINE__, __FUNCTION__, __TIMESTAMP__)
    #define THROW_TYPE_NODE_NOT_FOUND(s) throw BipartiteGraphNodeNotFoundException(s, __LINE__, __FUNCTION__, __TIMESTAMP__)
    #define THROW_TYPE_NULL_POINTER(s) throw BipartiteGraphNullPointerException(s, __LINE__, __FUNCTION__, __TIMESTAMP__);
    #define THROW_TYPE_INDEX_OUT_OF_BOUNDS(s) throw BipartiteGraphIndexOutOfBoundsException(s, __LINE__, __FUNCTION__, __TIMESTAMP__);
    #define THROW_TYPE_OBJECT_EXISTS(s) throw BipartiteGraphObjectExistsException(s, __LINE__, __FUNCTION__, __TIMESTAMP__);

    enum ExceptionType {TYPE_EXCEPTION,
                       TYPE_NODE_NOT_FOUND,
                       TYPE_NULL_POINTER,
                       TYPE_INDEX_OUT_OF_BOUNDS,
                       TYPE_OBJECT_EXISTS};

    class Exception : public std::exception
    {
    public:
        Exception(){
            text = "";
            line = 0;
            function = "";
            timestamp = "";
        }

        Exception(std::string text, int line, std::string function, std::string timestamp):text(text),line(line),function(function),timestamp(timestamp) {}

        virtual const char* printE() const throw() {
            fullString = "\nError - ";
            switch(type)
            {
            case(TYPE_EXCEPTION):
                fullString += "Exception. ";
                break;
            case(TYPE_NODE_NOT_FOUND):
                fullString += "Node not found. ";
                break;
            case(TYPE_NULL_POINTER):
                fullString += "Null pointer exeption. ";
                break;
            case(TYPE_INDEX_OUT_OF_BOUNDS):
                fullString += "IndexOutOfBounds. ";
                break;
            case(TYPE_OBJECT_EXISTS):
                fullString += "Object already exists. ";
                break;
            }

              fullString += "Message - ";
              fullString += text;
              fullString += ". Function ";
              fullString +=function;
              fullString +=". In line: ";
              fullString +=line;
              fullString +=". Build from: ";
              fullString +=timestamp;
              fullString +="\n";
              return fullString.c_str();
        }

        ExceptionType getExceptionType() const { return type; }

    protected:
        ExceptionType type;
        std::string text;
        int line;
        std::string function;
        std::string timestamp;
        mutable std::string fullString;
        };

    class BipartiteGraphNodeNotFoundException: public Exception
    {
    public:
        BipartiteGraphNodeNotFoundException(std::string text, int line, std::string function, std::string timestamp):
            Exception(text, line, function, timestamp) {
            type = TYPE_NODE_NOT_FOUND;
        }
    };

    class BipartiteGraphNullPointerException: public Exception
    {
    public:
        BipartiteGraphNullPointerException(std::string text, int line, std::string function, std::string timestamp):
            Exception(text, line, function, timestamp) {
            type = TYPE_NULL_POINTER;
        }
    };

    class BipartiteGraphIndexOutOfBoundsException: public Exception
    {
    public:
        BipartiteGraphIndexOutOfBoundsException(std::string text, int line, std::string function, std::string timestamp):
            Exception(text, line, function, timestamp) {
            type = TYPE_INDEX_OUT_OF_BOUNDS;
        }
    };

    class BipartiteGraphObjectExistsException: public Exception
    {
    public:
        BipartiteGraphObjectExistsException(std::string text, int line, std::string function, std::string timestamp):
            Exception(text, line, function, timestamp) {
            type = TYPE_OBJECT_EXISTS;
        }
    };

    /* Шаблон вершины графа */
    template <class Type> class Node{
    private:
        bool check; // определяет, каким "цветом" окрашена вершина
        Type data;  // хранимый объект
    public:
        Node() {}
        Node(Type d, bool c){
            data = d;
            check = c;
        }
        Type getData() const {
            return data;
        }
        void setData(Type d) {
            data = d;
        }
        bool isCheck(){
            return check;
        }
        void setCheck(bool c){
            check = c;
        }

        friend std::ostream& operator<<(std::ostream& out, Node<Type>* dt)
        {
            out << dt->getData() << "\n";
            out << dt->isCheck();
            return out;
        }
        friend bool operator==(Node<Type>& a, Node<Type>& other)
        {
            return (a.getData() ==
                    other.getData()) && (a.isCheck() == other.isCheck());
        }
        /*friend bool operator!=(const Node<Type>& other)
        {
            return !(this == other);
        }*/
    };

    /* Шаблон ребра графа(пара вершин) */
    template <class Type> class PairNode{
    private:
        Node<Type> *first;  // первая вершина ребра
        Node<Type> *second; // вторая вершина ребра
    public:
        PairNode() {}
        PairNode(Node<Type> *f,Node<Type> *s) {
            first = f;
            second = s;
        }
        Node<Type>* getFisrt() const {
            return first;
        }
        void setFisrt(Node<Type> f){
            first = &f;
        }
        Node<Type>* getSecond(){
            return second;
        }
        void setSecond(Node<Type> s){
            second = s;
        }
        friend std::ostream& operator<<(std::ostream& out, PairNode<Type>* dt)
        {
            out << "(" << dt->getFisrt() << "," << dt->getSecond() << ")";
            return out;
        }
        bool operator==(const PairNode<Type>& other)
        {
            return (first->getData() == other.getFisrt().getData()) && (second->getData() == other.getSecond().getData());
        }
        bool operator!=(const PairNode<Type>& other)
        {
            return this->first != other.getFisrt();
        }
    };

    /* Шаблон Двудольного графа */

    template <class Type> class BipartiteGraph
    {
    private:
        std::list<Node<Type>*> vertixs;  // список вершин графа
        std::list<PairNode<Type>*> pairs;    // список ребер графа
        int sizeV, sizeP;
    public:
        BipartiteGraph() {}
        // размер списка вершин
        int getSizeVertixs() {
            return vertixs.size();
        }

        /* Инвариант проверки, что граф двудольный */
        bool invariantBigraph() {
            IteratorPairs ip = beginPairs();
            while (ip != endPairs()) {
                PairNode<Type>* pn = *ip;
                if (pn->getFisrt()->isCheck() == pn->getSecond()->isCheck()) {
                    return false;
                }
            }
            return true;
        }

        /* Операции с вершинами */
        bool addVertix(Type n, bool c){
            auto vertexPos = find_if(vertixs.begin(), vertixs.end(), [n,c](Node<Type>* i)
            {
              return i->getData() == n && i->isCheck() == c;
            });

            try {
                if(vertexPos != vertixs.end())
                {
                  THROW_TYPE_OBJECT_EXISTS("Vertex already exist");
                } else {
                    auto newNode = allocator.allocateVertix(n,c);
                    vertixs.push_back(newNode);
                    auto vertexPosBeforeAdd = find_if(vertixs.begin(), vertixs.end(), [n,c](Node<Type>* i)
                    {
                      return i->getData() == n && i->isCheck() == c;
                    });
                    if(vertexPosBeforeAdd != vertixs.end())
                    {
                        return true;
                    } else {
                        THROW_TYPE_OBJECT_EXISTS("Vertex not add");
                    }
                }
            } catch(Exception e) {
                std::cerr << e.printE();
                return false;
            }
        }
        void popFrontVertix() {
            try {
                if(vertixs.size() == 0)
                {
                    THROW_TYPE_NULL_POINTER("List already empty");
                } else {
                    removeVertixNode(vertixs.front());
                }
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }
        void popBackVertix() {
            try {
                if(vertixs.size() == 0)
                {
                  THROW_TYPE_NULL_POINTER("List already empty");
                } else {
                  removeVertixNode(vertixs.back());
                }
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }

        Node<Type>* getVertixNodeByNumber(int n){
            try {
                if (n < vertixs.size()) {
                    IteratorVertixs v = beginVertixs();
                    for(int i = 0; i < n;i++){
                        v++;
                    }
                    return *v;
                } else {
                    THROW_TYPE_INDEX_OUT_OF_BOUNDS("The index is outside the list");
                }
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }

        Node<Type>* getVertixNode(Type d, bool ch){
            bool check = false;
            IteratorVertixs v = beginVertixs();
            for(; v != endVertixs(); ++v){
                Node<Type>* node = *v;
                if (node->getData() == d && node->isCheck() == ch) {
                    check = true;
                    break;
                }
            }
            try {
                if (check) {
                    return *v;
                } else {
                    THROW_TYPE_NODE_NOT_FOUND("Node not found in graph");
                }
            } catch(BipartiteGraphNodeNotFoundException e) {
                std::cerr << e.printE();
            }
        }

        void removeVertixNodeByNumber(int n){
            try {
                if (n <= vertixs.size()) {
                    IteratorVertixs v = beginVertixs();
                    for(int i = 0; i < n;i++){
                        ++v;
                    }
                    std::list<PairNode<Type>*> list_remove = getPairsList(*v);
                    for (typename std::list<PairNode<Type>*>::iterator it=list_remove.begin(); it != list_remove.end(); ++it) {
                        allocator.deletePair(*it);
                        pairs.remove(*it);
                    }
                    allocator.deleteVertix(*v);
                    vertixs.remove(*v);
                } else {
                    THROW_TYPE_INDEX_OUT_OF_BOUNDS("The index is outside the list");
                }
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }

        // Удалить вершину и все связанные ребра по Node
        void removeVertixNode(Node<Type>* t){
            try {
                auto vertexPos = find_if(vertixs.begin(), vertixs.end(), [t](Node<Type>* i)
                {
                  return i == t;
                });
                if (vertexPos == vertixs.end()) {
                    THROW_TYPE_NODE_NOT_FOUND("Such an object was not found in the list");
                } else {
                    std::list<PairNode<Type>*> list_remove = getPairsList(t);
                    for (typename std::list<PairNode<Type>*>::iterator it=list_remove.begin(); it != list_remove.end(); ++it) {
                        allocator.deletePair(*it);
                        pairs.remove(*it);
                    }
                    allocator.deleteVertix(t);
                    vertixs.remove(t);
                }
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }

        // Метод, удаляющий все True вершины
        void removeAllTrue() {
            IteratorVertixs v = beginVertixs();
            std::vector<Node<Type>*> myVector = findAllNode(true);
            for(int i = 0; i < myVector.size(); i++) {
                removeVertixNode(myVector[i]);
            }
        }

        // Метод, удаляющий все False вершины
        void removeAllFalse() {
            IteratorVertixs v = beginVertixs();
            std::vector<Node<Type>*> myVector = findAllNode(false);
            for(int i = 0; i < myVector.size(); i++) {
                removeVertixNode(myVector[i]);
            }
        }

        std::vector<Node<Type>*> findAllNode(bool c) {
            std::vector<Node<Type>*> myVector;
            int i = 0;
            for(IteratorVertixs v = beginVertixs(); v != endVertixs(); v++){
                Node<Type>* node = *v;
                if (c == node->isCheck()) {
                    myVector.insert(myVector.end(),node);
                }
                i++;
            }
            return myVector;
        }

        // Метод, возвращающий список ребер выбранной вершины
        std::list<PairNode<Type>*> getPairsList(Node<Type>* t){
            std::list<PairNode<Type>*> pairs;
            IteratorPairs v = beginPairs();
            for(; v != endPairs(); v++) {
                PairNode<Type>* temp =*v;
                if (temp->getFisrt()->getData() == t->getData() || temp->getSecond()->getData() == t->getData()) {
                    pairs.push_back(temp);
                }
            }
            return pairs;
        }

        // Итератор для списка вершин
        class IteratorVertixs {
            typename std::list<Node<Type>*>::iterator current = NULL;
        public:
            typename std::list<Node<Type>*>::iterator getCurrent() {return current;}
            IteratorVertixs(typename std::list<Node<Type>*>::iterator current):current(current){}
            IteratorVertixs& operator=(const IteratorVertixs& other)
            {
                if (this != &other)
                {
                    current = other.current;
                }
                return *this;
            }

            IteratorVertixs& operator++()
            {
                current++;
                return *this;
            }

            IteratorVertixs operator++(int)
            {
                current++;
                return *this;
            }

            IteratorVertixs& operator--()
            {
                current--;
                return *this;
            }

            IteratorVertixs operator--(int)
            {
                current--;
                return *this;
            }

            bool operator==(const IteratorVertixs& other)
            {
                return this->current.operator ==(other.current);
            }

            bool operator!=(const IteratorVertixs& other)
            {
                return this->current.operator !=(other.current);
            }

            Node<Type>* operator*(){
                return *current;
            }

            Node<Type>* operator->()
            {
                return *current;
            }

            bool isEmpty() {
                return current == NULL;
            }

        };
        IteratorVertixs beginVertixs() {
            return IteratorVertixs(vertixs.begin());
        }
        IteratorVertixs endVertixs() {
            return IteratorVertixs(vertixs.end());
        }

        /* Операции с ребрами */
        void addPair(Node<Type>* f, Node<Type>* s){
            auto vertexPos = find_if(pairs.begin(), pairs.end(), [f,s](PairNode<Type>* i)
            {
              return i->getFisrt()->getData() == f->getData() && i->getSecond()->getData() == s->getData();
            });

            try {
                if(vertexPos != pairs.end())
                {
                  THROW_TYPE_OBJECT_EXISTS("Pairs already exist!");
                  return;
                }
                auto newPairs = allocator.allocatePairNode(*f,*s);
                pairs.push_back(newPairs);
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }
        void popFrontPair() {
            try {
                if(pairs.size() == 0)
                {
                  THROW_TYPE_NULL_POINTER("List pairs already empty");
                  return;
                }
                pairs.pop_front();
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }
        void popBackPair() {
            try {
                if(pairs.size() == 0)
                {
                  THROW_TYPE_NULL_POINTER("List pairs already empty");
                  return;
                }
                pairs.pop_back();
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }
        PairNode<Type>* getPairNode(int n){
            try {
                if(pairs.size < n)
                {
                  THROW_TYPE_INDEX_OUT_OF_BOUNDS("The index is not included in the list dimensions");
                  return;
                }
                IteratorPairs v = beginPairs();
                for(int i = 0; i < n;i++){
                    ++v;
                }
                return *v;
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }
        int findPairNode(Node<Type>* t){
            int result = -1, i = 0;
            for(IteratorPairs v = beginPairs(); v != endPairs();++v){
                PairNode<Type>* pairNode = *v;
                if (pairNode->getFisrt() == t || pairNode->getSecond() == t) {
                    result = i;
                    break;
                }
                i++;
            }
            return result;
        }

        void removePairNode(int n){
            try {
                if(pairs.size() < n)
                {
                  THROW_TYPE_INDEX_OUT_OF_BOUNDS("The index is not included in the list dimensions");
                  return;
                }
                IteratorPairs v = beginPairs();
                for(int i = 0; i < n;i++){
                    ++v;
                }
                pairs.erase(v.getCurrent());
            } catch(Exception e) {
                std::cerr << e.printE();
            }
        }

        /* Итератор для списка вершин */
        class IteratorPairs {
            typename std::list<PairNode<Type>*>::iterator current = NULL;
        public:
            typename std::list<PairNode<Type>*>::iterator getCurrent() {return current;}
            IteratorPairs(typename std::list<PairNode<Type>*>::iterator current):current(current){}
            IteratorPairs& operator=(const IteratorPairs& other)
            {
                if (this != &other)
                {
                    current = other.current;
                }
                return *this;
            }

            IteratorPairs& operator++()
            {
                current++;
                return *this;
            }

            IteratorPairs operator++(int)
            {
                current++;
                return *this;
            }

            IteratorPairs& operator--()
            {
                current--;
                return *this;
            }

            IteratorPairs& operator--(int)
            {
                current--;
                return *this;
            }

            bool operator==(const IteratorPairs& other)
            {
                return this->current.operator ==(other.current);
            }

            bool operator!=(const IteratorPairs& other)
            {
                return this->current.operator !=(other.current);
            }

            PairNode<Type>* operator*(){
                return *current;
            }

            PairNode<Type>* operator->()
            {
                return current;
            }

            bool isEmpty() {
                return current == NULL;
            }
        };
        IteratorPairs beginPairs() {
            return IteratorPairs(pairs.begin());
        }
        IteratorPairs endPairs() {
            return IteratorPairs(pairs.end());
        }

        // Удалить вершину и все связанные ребра по итератору
        void removeVertixNode(IteratorVertixs g){
            Node<Type>* t = (*g);
            IteratorVertixs v = beginVertixs();
            for(; v != endVertixs(); v++) {
                Node<Type>* temp =*v;
                if (temp->getData() == t->getData()) {
                    break;
                }
            }
            int find = findPairNode(*v);
            while (find != -1) {
                removePairNode(find);
                find = findPairNode(*v);
            }
            vertixs.erase(v.getCurrent());
        }

        void clearGraph() {
            while(vertixs.size() > 0){
                popFrontVertix();
            }
        }

        void Serialize(std::string filename) {
            std::ofstream fout;
            fout.open(filename, std::ofstream::binary); // связываем объект с файлом

            if (fout.is_open()) {
                fout << vertixs.size() << "\n";
                fout << pairs.size() << "\n";
                for_each (vertixs.begin(), vertixs.end(), [&fout](Node<Type>* i) {
                    fout << i << "\n";
                });

                for_each (pairs.begin(), pairs.end(), [&fout](PairNode<Type>* i) {
                    fout << i->getFisrt() << "\n";
                    fout << i->getSecond() << "\n";
                });
                fout.flush();
                fout.close();
            } else {
                std::cout << "Error open file";
            }
        }

        void Deserialize(std::string filename) {
            std::ifstream fin(filename, std::ofstream::in);
            size_t sizeV, sizeP;
            fin >> sizeV;
            fin >> sizeP;
            Type data;
            bool check;
            for (int  i = 0; i < sizeV; i++) {
                fin >> data;
                fin >> check;
                auto newNode = allocator.allocateVertix(data,check);
                vertixs.push_back(newNode);
            }
            Type first_data, second_data;
            bool first_check,second_check;
            for (int  i = 0; i < sizeP; i++) {
                fin >> first_data;
                fin >> first_check;
                fin >> second_data;
                fin >> second_check;
                auto pairNode = allocator.allocatePairNode(*getVertixNode(first_data,first_check),
                                                           *getVertixNode(second_data,second_check));
                pairs.push_back(pairNode);
            }
            std::cout << sizeV << std::endl;
            std::cout << sizeP << std::endl;
        }

        friend std::ostream& operator<<(std::ostream& out, BipartiteGraph<Type>& dt)
        {
            out << dt.vertixs.size() << std::endl;
            out << dt.pairs.size()<< std::endl;
            out << "Vertixs:"<< std::endl;
            for_each (dt.vertixs.begin(), dt.vertixs.end(), [&out](Node<Type>* i) {
                out << i<< std::endl;
            });
            out << "Pairs:"<< std::endl;
            for_each (dt.pairs.begin(), dt.pairs.end(), [&out](PairNode<Type>* i) {
                out << i->getFisrt()<< std::endl;
                out << i->getSecond()<< std::endl;
            });
            return out;
        }

        friend std::istream& operator>> ( std::istream& is, BipartiteGraph<Type>& dt )
        {
            int sizeV, sizeP;
            is >> sizeV;
            is >> sizeP;
            Node<Type> node;
            for(int i = 0; i < sizeP; i++) {
                is >> node;
            }

            for(int i = 0; i < sizeP; i++) {
                is >> node;
            }
            for_each (dt.pairs.begin(), dt.pairs.end(), [&is](PairNode<Type>* i) {
                is >> i->getFisrt();
                is >> i->getSecond();
            });
            return is;
        }

/*
        std::ostream &graphToString(std::ostream &stream)
        {
            stream << "All vertixs:";
            IteratorVertixs v = beginVertixs();
            while (v!=endVertixs()) {
                stream << (*v);
                stream << "; ";
                v++;
            }
            return stream;
        }
*/
private:
        class Allocator {
        public:
            Allocator(){}
            virtual ~Allocator() {
                deleteAll();
            }

            Node<Type>* allocateVertix(Type& t) {
                Node<Type>* newNode = new Node<Type>(t);
                vertexes_pool.push_back(newNode);
                return newNode;
            }

            Node<Type>* allocateVertix(Type& t, bool b) {
                Node<Type>* newNode = new Node<Type>(t,b);
                vertexes_pool.push_back(newNode);
                return newNode;
            }

            PairNode<Type>* allocatePairNode(Node<Type>& f, Node<Type>& s){
                PairNode<Type>* newPair = new PairNode<Type>(&f,&s);
                pairs_pool.push_back(newPair);
                return newPair;
            }

            void deleteVertix(Node<Type>* d) {
                auto pos = find(vertexes_pool.begin(), vertexes_pool.end(), d);

                if(pos == vertexes_pool.end())
                {
                  std::cout << "can't find returned value in vertex pool!";
                  return;
                }
                vertexes_pool.erase(pos);
                delete d;
            }

            void deletePair(PairNode<Type>* d) {
                auto pos = find(pairs_pool.begin(), pairs_pool.end(), d);

                if(pos == pairs_pool.end())
                {
                  std::cout << "can't find returned value in pairs pool!";
                  return;
                }
                pairs_pool.erase(pos);
                delete d;
            }

            void deleteAll() {
                for_each(vertexes_pool.begin(), vertexes_pool.end(),
                                  [](Node<Type>* i) {delete i;});

                for_each(pairs_pool.begin(), pairs_pool.end(),
                              [](PairNode<Type>* i) {delete i;});
                vertexes_pool.clear();
                pairs_pool.clear();
            }

        private:
            std::list<Node<Type>*> vertexes_pool;
            std::list<PairNode<Type>*> pairs_pool;
        };

private:
        Allocator allocator;
    };
}

#endif // BIPARTITEGRAPH_H
