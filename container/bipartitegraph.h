#ifndef BIPARTITEGRAPH_H
#define BIPARTITEGRAPH_H
#include <list>

template <class Type> class Node{
private:
    bool check; // определяет, каким "цветом" окрашена вершина
    Type data;  // хранимый объект
public:
    Node(); // Пустой конструктор
    Node(Type d);   // Конструктор с объектом
    Node(Type d, bool c);   // Конструктор с объектом и "цветом" вершины
    Type getData();
    void setData(Type d);
    bool isCheck();
    void setCheck(bool c);
};

template <class Type> class PairNode{
private:
    Node<Type> *first,  // первая вершина ребра
            *second;    // вторая вершина ребра
public:
    PairNode();
    PairNode(Node<Type> f,Node<Type> s);
    Node<Type> getFisrt();
    void setFisrt(Node<Type> f);
    Node<Type> getSecond();
    void setSecond(Node<Type> s);
};

template <class Type> class BipartiteGraph
{
private:
    std::list<Node<Type>> vertixs;  // список вершин графа
    std::list<PairNode<Type>> pairs;    // список ребер графа
public:
    BipartiteGraph();
};

#endif // BIPARTITEGRAPH_H
