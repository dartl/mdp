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

    friend std::ostream& operator<<(std::ostream& out, Node<Type> dt)
    {
        out << dt.getData();
        return out;
    }
};

/* Шаблон ребра графа(пара вершин) */
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

/* Шаблон Двудольного графа */
template <class Type> class BipartiteGraph
{
private:
    std::list<Node<Type>> vertixs;  // список вершин графа
    std::list<PairNode<Type>> pairs;    // список ребер графа
public:
    BipartiteGraph() {}
    void addVertix(Type n){
        vertixs.push_front(new Node<Type>(n));
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

    /* Итератор для списка вершин */
    class IteratorVertixs {
        typename std::list<Node<Type>>::iterator current = NULL;
    public:
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
            else return current;
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
};

#endif // BIPARTITEGRAPH_H
