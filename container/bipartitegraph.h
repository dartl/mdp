#ifndef BIPARTITEGRAPH_H
#define BIPARTITEGRAPH_H
#include <list>

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
    Type getData() {
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
};

template <class Type> class PairNode{
private:
    Node<Type> *first;  // первая вершина ребра
    Node<Type> *second; // вторая вершина ребра
public:
    PairNode() {}
    PairNode(Node<Type> f,Node<Type> s) {
        first = &f;
        second = &s;
    }
    Node<Type> getFisrt(){
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
};

template <class Type> class BipartiteGraph
{
private:
    std::list<Node<Type>> vertixs;  // список вершин графа
    std::list<PairNode<Type>> pairs;    // список ребер графа
public:
    BipartiteGraph() {}
    void add(Type n){
        vertixs.push_front(new Node<Type>(n));
    }
    void add(Type n, bool c){
        Node<Type> temp(n,c);
        vertixs.push_front(temp);
    }
};

#endif // BIPARTITEGRAPH_H
