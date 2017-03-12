#ifndef BIPARTITEGRAPH_H
#define BIPARTITEGRAPH_H
#include <list>
#include <iostream>

/* Шаблон вершины графа */
template <class Type> class Node{
private:
    bool check; // определяет, каким "цветом" окрашена вершина
    Type data;  // хранимый объект
public:
    Node() {}
    Node(Type d){
        data = d;
    }
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

    friend std::ostream& operator<<(std::ostream& out, Node<Type> dt)
    {
        out << dt.getData();
        return out;
    }
    bool operator==(const Node<Type>& other)
    {
        return this->data ==
                other.getData();
    }
    bool operator!=(const Node<Type>& other)
    {
        return !(*this ==
                 other);
    }
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
    Node<Type> getFisrt() const {
        return *first;
    }
    void setFisrt(Node<Type> f){
        first = &f;
    }
    Node<Type> getSecond(){
        return *second;
    }
    void setSecond(Node<Type> s){
        second = s;
    }
    friend std::ostream& operator<<(std::ostream& out, PairNode<Type> dt)
    {
        out << "(" << dt.getFisrt() << "," << dt.getSecond() << ")";
        return out;
    }
    bool operator==(const PairNode<Type>& other)
    {
        Node<Type> f = other.getFisrt();
        return first->getData() == f.getData();
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
    std::list<Node<Type>> vertixs;  // список вершин графа
    std::list<PairNode<Type>> pairs;    // список ребер графа
public:
    BipartiteGraph() {}
    /* Операции с вершинами */
    void addVertix(Type n){
        Node<Type> temp(n);
        vertixs.push_back(temp);
    }
    void addVertix(Type n, bool c){
        Node<Type> temp(n,c);
        vertixs.push_back(temp);
    }
    void popFrontVertix() {
        vertixs.pop_front();
    }
    void popBackVertix() {
        vertixs.pop_back();
    }
    Node<Type>& getVertixNode(int n){
        IteratorVertixs v = beginVertixs();
        for(int i = 0; i < n;i++){
            ++v;
        }
        return *v;
    }
    void removeVertixNode(int n){
        IteratorVertixs v = beginVertixs();
        for(int i = 0; i < n;i++){
            ++v;
        }
        int find = findPairNode(*v);
        while (find != -1) {
            removePairNode(find);
            find = findPairNode(*v);
        }
        vertixs.erase(v.getCurrent());
    }

    // Итератор для списка вершин
    class IteratorVertixs {
        typename std::list<Node<Type>>::iterator current = NULL;
    public:
        typename std::list<Node<Type>>::iterator getCurrent() {return current;}
        IteratorVertixs(typename std::list<Node<Type>>::iterator current):current(current){}
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

        IteratorVertixs& operator--()
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

        Node<Type>& operator*(){
            return *current;
        }

        Node<Type>* operator->()
        {
            else current;
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
    void addPair(Node<Type> *f, Node<Type> *s){
        PairNode<Type> temp(f,s);
        pairs.push_back(temp);
    }
    void popFrontPair() {
        pairs.pop_front();
    }
    void popBackPair() {
        pairs.pop_back();
    }
    PairNode<Type>& getPairNode(int n){
        IteratorPairs v = beginPairs();
        for(int i = 0; i < n;i++){
            ++v;
        }
        return *v;
    }
    int findPairNode(Node<Type> t){
        int result = -1, i = 0;
        for(IteratorPairs v = beginPairs(); v != endPairs();++v){
            PairNode<Type> pairNode = *v;
            if (pairNode.getFisrt() == t || pairNode.getSecond() == t) {
                result = i;
                break;
            }
            i++;
        }
        return result;
    }
    void removePairNode(int n){
        IteratorPairs v = beginPairs();
        for(int i = 0; i < n;i++){
            ++v;
        }
        pairs.erase(v.getCurrent());
    }

    /* Итератор для списка вершин */
    class IteratorPairs {
        typename std::list<PairNode<Type>>::iterator current = NULL;
    public:
        typename std::list<PairNode<Type>>::iterator getCurrent() {return current;}
        IteratorPairs(typename std::list<PairNode<Type>>::iterator current):current(current){}
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

        IteratorPairs& operator--()
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

        PairNode<Type>& operator*(){
            return *current;
        }

        PairNode<Type>* operator->()
        {
            else return current;
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

};

#endif // BIPARTITEGRAPH_H
