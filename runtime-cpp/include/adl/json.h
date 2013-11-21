#ifndef ADL_JSON_H
#define ADL_JSON_H

#include <stdint.h>
#include <string> 

#include <adl/types.h>

namespace ADL {

class JsonWriter
{
public:
    virtual void startObject() = 0;
    virtual void field( const std::string &f ) = 0;
    virtual void endObject() = 0;

    virtual void startArray() = 0;
    virtual void endArray() = 0;

    virtual void nullV() = 0;
    virtual void boolV( bool v ) = 0;
    virtual void stringV( const std::string &v ) = 0;
    virtual void intV( int64_t v ) = 0;
    virtual void uintV( uint64_t v ) = 0;
    virtual void doubleV( double v ) = 0;
};

class JsonReader
{
public:
    enum Type {
        START_OBJECT,
        FIELD,
        END_OBJECT,
        START_ARRAY,
        END_ARRAY,
        NULLV,
        BOOLEAN,
        STRING,
        NUMBER,
        END_OF_STREAM
    };

    // Get the type of the current item
    virtual Type type() = 0;

    // Step to the next stream item
    virtual void next() = 0;

    // When type() == FIELD, this function is
    // to access the fieldname
    virtual const std::string & fieldName() = 0;

    // When type() == BOOLEAN, this function is
    // to access the numeric value
    virtual bool boolV() = 0;

    // When type() == NUMBER, this function is
    // to access the numeric value
    virtual int64_t intV() = 0;

    // When type() == NUMBER, this function is
    // to access the numeric value
    virtual uint64_t uintV() = 0;

    // When type() == NUMBER, this function is
    // to access the numeric value
    virtual double doubleV() = 0;

    // When type() == STRING, this function is
    // to access the string value
    virtual const std::string & stringV() = 0;
};

template <class T>
class Serialiser
{
public:

    // Basic serialisation operations.

    virtual void toJson( JsonWriter &json, const T & v ) const = 0;
    virtual void fromJson( T &v, JsonReader &json ) const = 0;

    typedef std::shared_ptr< Serialiser<T> > Ptr;
};

// This is to contain flags to control the serialisation
// process (eg for versioning) 
struct SerialiserFlags
{
};

// A type is serialisable if we can construct a serialiser for
// it
template <class T>
struct Serialisable
{
    static typename Serialiser<T>::Ptr serialiser(const SerialiserFlags &);
};


struct json_parse_failure : public std::exception
{
};

inline
bool match0( JsonReader &json, JsonReader::Type t )
{
    if( json.type() == t )
    {
        json.next();
        return true;
    }
    return false;
};

inline
void match( JsonReader &json, JsonReader::Type t )
{
    if( json.type() == t )
        json.next();
    else
        throw json_parse_failure();
};

// Skip over the complete json object currently pointed at.
void ignore( JsonReader &json );

inline bool
matchField0( const std::string &f, JsonReader &json )
{
    if( json.type() != JsonReader::FIELD )
        throw json_parse_failure();
    bool match = json.fieldName() == f;
    if( match )
        json.next();
    return match;
}

template <class T>
void
writeField( JsonWriter &json, typename Serialiser<T>::Ptr js, const std::string &f, const T &v )
{
    json.field( f );
    js->toJson( json, v );
};

template <class T>
bool
readField( typename Serialiser<T>::Ptr js, T &v, const std::string &f, JsonReader &json )
{
    if( json.type() != JsonReader::FIELD )
        throw json_parse_failure();
    if( json.fieldName() != f )
        return false;
    json.next();
    js->fromJson( v, json );
};

bool ignoreField( JsonReader &json );


//----------------------------------------------------------------------
// Serialisation for primitive/builtin types


template <> 
struct Serialisable<Void>
{
    static Serialiser<Void>::Ptr serialiser( const SerialiserFlags &  );
};

template <> 
struct Serialisable<bool>
{
    static Serialiser<bool>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<int8_t>
{
    static Serialiser<int8_t>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<int16_t>
{
    static Serialiser<int16_t>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<int32_t>
{
    static Serialiser<int32_t>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<int64_t>
{
    static Serialiser<int64_t>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<uint8_t>
{
    static Serialiser<uint8_t>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<uint16_t>
{
    static Serialiser<uint16_t>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<uint32_t>
{
    static Serialiser<uint32_t>::Ptr serialiser( const SerialiserFlags & );
};

template <> 
struct Serialisable<uint64_t>
{
    static Serialiser<uint64_t>::Ptr serialiser(const SerialiserFlags &);
};

template <>
struct Serialisable<float>
{
    static Serialiser<float>::Ptr serialiser(const SerialiserFlags &);
};

template <>
struct Serialisable<double>
{
    static Serialiser<double>::Ptr serialiser(const SerialiserFlags &);
};

template <>
struct Serialisable<std::string>
{
    static Serialiser<std::string>::Ptr serialiser(const SerialiserFlags &);
};

template <>
struct Serialisable<ByteVector>
{
    static Serialiser<ByteVector>::Ptr serialiser(const SerialiserFlags &);
};

template <class T>
struct Serialisable<std::vector<T>>
{
    class S : public Serialiser<T>
    {
    public:
        S( const SerialiserFlags & sf ) 
            : js_( Serialisable<T>::serialiser(sf) )
        {}

        void toJson( JsonWriter &json, const std::vector<T> & v ) const
        {
            json.startArray();
            for( typename std::vector<T>::const_iterator vi = v.begin(); vi != v.end(); vi++ )
                js_->toJson( json, *vi );
            json.endArray();
        }

        void fromJson( std::vector<T> &v, JsonReader &json ) const
        {
            match( json, JsonReader::START_ARRAY );
            while( !match0( json, JsonReader::END_ARRAY ) )
            {
                T v1;
                js_->fromJson( v1, json );
                v.push_back(v1);
            }
        }

    private:
        typename Serialiser<T>::Ptr js_;
    };

    static typename Serialiser<std::vector<T>>::Ptr serialiser(const SerialiserFlags & sf)
    {
        return new S(sf);
    }
};

};

#endif
